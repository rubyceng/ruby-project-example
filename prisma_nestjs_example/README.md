# Prisma + NestJS + DDD设计 Example

## 📁 项目结构

```
❯ tree -I "node_modules|.git|dist"
prisma_nestjs_example/
├── prisma
│   ├── migrations
│   │   └── migration_lock.toml
│   └── schema.prisma
├── src
│   ├── app.module.ts
│   ├── main.ts
│   ├── modules
│   │   └── product
│   │       ├── application
│   │       │   ├── dtos
│   │       │   │   ├── create-product.dto.ts
│   │       │   │   └── vo
│   │       │   │       └── product.vo.ts
│   │       │   ├── mappers
│   │       │   │   └── product.mapper.ts
│   │       │   └── services
│   │       │       └── product.service.ts
│   │       ├── controller
│   │       │   └── product.controller.ts
│   │       ├── domain
│   │       │   ├── aggregates
│   │       │   │   └── product.aggregate-root.ts
│   │       │   └── repositories
│   │       │       └── product.repository.ts
│   │       ├── infrastructure
│   │       │   ├── mappers
│   │       │   │   └── product.prisma-mapper.ts
│   │       │   └── repositories
│   │       │       └── prisma-product.repository.ts
│   │       └── product.module.ts
│   └── shared
│       ├── domain
│       │   ├── aggregate-root.base.ts
│       │   ├── entity.base.ts
│       │   └── value-object.entity.ts
│       └── infrastructure
│           └── prisma
│               ├── prisma.module.ts
│               └── prisma.service.ts
├── nest-cli.json
├── package.json
├── pnpm-lock.yaml
├── README.md
└── tsconfig.json
```

---

## 🛍️ 场景一：商品管理 (Product)

商品管理，从表面看，似乎只是简单的增删改查（CRUD）。在传统架构中，这可能就是一个Controller直接调用一个包含了所有数据库操作的Service。但即使是这样简单的场景，DDD也为我们注入了纪律性和长远的健壮性。

### 📋 业务流程

- **创建商品**：管理员录入一个新商品，包含名称、价格、SKU、初始库存等信息。
- **查询商品**：用户或系统可以根据ID或SKU查询商品详情。
- **更新库存**：在售出后，商品的库存需要被扣减。

### 🧠 DDD思想解读

#### 1. ProductAggregate：不仅仅是数据，更是业务规则的守护者

传统MVC中的Product实体通常是一个"贫血"模型，只有一堆getter/setter。而我们的ProductAggregate则是一个"充血"模型，它是有生命和智慧的。

**不变量保护 (Invariant Protection)：** 聚合根的首要职责是保护其内部数据的一致性和业务规则的正确性，我们称之为"不变量"。在我们的代码中，ProductAggregate.create()工厂方法就是这个不变量的"守门人"。

```typescript
// src/modules/product/domain/aggregates/product.aggregate-root.ts
public static create(props: Omit<ProductProps, ...>): ProductAggregate {
  // 规则1：价格不能为负
  if (props.price < 0) {
    throw new Error('Product price cannot be negative.');
  }
  // 规则2：库存不能为负
  if (props.stock < 0) {
    throw new Error('Product stock cannot be negative.');
  }
  return new ProductAggregate(props);
}
```

任何试图创建不合法产品的尝试都会在领域层被立刻拒绝，而不是等到数据存入数据库时才报错。

**封装业务行为：** 当需要修改库存时，我们不是提供一个setStock(number)方法，而是提供一个意图明确的decreaseStock(quantity: number)方法。

```typescript
public decreaseStock(quantity: number): void {
  // 封装了"库存不能被减成负数"的业务规则
  if (this.props.stock < quantity) {
    throw new Error('Insufficient stock.');
  }
  this.props.stock -= quantity;
  this.props.updatedAt = new Date();
}
```

这确保了对聚合根状态的所有修改都是通过一个明确定义的、符合业务规则的"动词"来完成的。

#### 2. ProductRepository：隔离技术复杂性

我们定义了一个抽象的ProductRepository接口在领域层，而将基于Prisma的具体实现放在了基础设施层。这带来了巨大的好处：

- **核心业务纯粹性**：我们的ProductAggregate和应用层的ProductService完全不知道Prisma的存在。它们只依赖于那个抽象的、稳定的接口。
- **可测试性**：在为ProductService编写单元测试时，我们不需要连接一个真实的数据库。我们可以轻松地创建一个内存版的MockProductRepository来模拟数据存取，让测试变得飞快且无副作用。

> 💡 **关键洞察**  
> 这个简单的商品管理场景，告诉我们：DDD的价值在于从项目第一天起就建立起良好的纪律。它通过聚合根封装业务、通过仓储隔离技术，为系统未来的演进铺设了一条清晰、可控的道路。

---

## 📦 场景二：订单生命周期 (Order)

订单是系统的核心，其业务逻辑错综复杂。这正是传统架构的"滑铁卢"，也恰恰是DDD大放异彩的舞台。

### 📋 业务流程

- **添加商品到购物车**：用户选择商品和数量，将其加入购物车（一个DRAFT状态的订单）。
- **确认订单并结算**：用户确认购物车内容，系统应用可能的折扣，并生成最终待支付金额。
- **支付成功**：用户完成支付，系统需要触发一系列后续操作（扣库存、加积分、发通知等）。

### 🧠 DDD思想解读

#### 1. OrderAggregate：复杂业务关系的一致性保证

OrderAggregate是这个流程中的绝对主角。它管理着Order自身的状态，以及其内部OrderItem实体的集合。

**维护内部一致性：** 当一个商品被添加时，addItem方法不仅要处理OrderItem的增加或数量更新，还必须立即、原子地调用私有的recalculateTotal()方法来更新订单总价。

```typescript
// src/modules/order/domain/aggregates/order.aggregate-root.ts
public addItem(product: ProductSnapshot, quantity: number): void {
  // ... 检查库存、状态等规则 ...
  // ★ 关键：聚合根自己负责维护内部状态的一致性！
  this.recalculateTotal();
}
```

在传统MVC中，这个"更新总价"的逻辑极有可能被遗忘在OrderService的某个角落，导致数据不一致。而在DDD中，聚合根自身的设计就杜绝了这种可能。

**作为状态机：** OrderAggregate通过status字段和一系列业务方法（confirmForPayment, markAsPaid），构成了一个严谨的业务流程状态机。你不能对一个已经支付的订单再添加商品，这些规则都被封装在聚合根的方法中，保证了业务流程的正确流转。

#### 2. 同步计算 vs. 异步后果：领域事件

这是订单流程中最能体现DDD强大表达力的部分。

**同步计算：DiscountService（领域服务）的登场**  
在"确认订单并结算"这一步，我们必须同步地计算出最终价格。这个计算逻辑复杂（需要订单、用户、促销等多个聚合的信息），且主流程必须等待其结果。此时，领域服务应运而生。它负责执行这个跨聚合的计算，并立即返回结果，供主流程使用。

**异步后果：OrderPaidEvent（领域事件）的解耦魔法**  
在"支付成功"这一步，订单的核心职责已经完成。后续的"扣库存"、"加积分"都是这个核心事实引发的后果（Consequences）。此时，OrderAggregate的markAsPaid()方法不再去直接调用ProductRepository，而是发布一个OrderPaidEvent领域事件。

```typescript
// src/modules/order/domain/aggregates/order.aggregate-root.ts
public markAsPaid(): void {
  // ... 状态检查 ...
  this.props.status = OrderStatus.PAID;
  // ★ 宣布（Publish）一个事实，而不是执行（Command）一个动作
  this.addDomainEvent(new OrderPaidEvent(/* ... */));
}
```

这带来了革命性的改变：高度解耦、极强的可扩展性（符合开闭原则）、提升系统弹性和性能（通过最终一致性避免大事务）。

---

## 🔍 场景三：复杂验证规则的处理

### 📋 业务流程

在订单从 DRAFT 状态转为 PENDING_PAYMENT 之前，系统必须执行一项特殊的验证规则：

> "对于非VIP客户，如果订单总价超过5000元，或者订单中包含任何'奢侈品'分类的商品，那么该订单需要一个'高价值订单'的标记，并可能需要人工审核。"

### 🔬 分析：

- 这个验证逻辑显然很复杂，不适合放在OrderAggregate内部，因为它需要知道User的信息（是否VIP）和Product的信息（是否奢侈品）。
- 它必须在订单确认的同一个事务中同步完成。
- 最重要的是，这个服务的核心业务概念是"验证一个订单"。它的上下文完全是围绕"订单"这个模块的。
