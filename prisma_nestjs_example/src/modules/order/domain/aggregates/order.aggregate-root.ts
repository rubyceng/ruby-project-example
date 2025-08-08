import { OrderStatus } from '@prisma/client';
import { randomUUID } from 'crypto';
import {
  AggregateRoot,
  AggregateRootProps,
} from '../../../../shared/domain/aggregate-root.base';
import { OrderItem } from '../entities/order-item.entity';
import { OrderPaidEvent } from '../events/order-paid.event';

// 传入的商品参数，只包含必要信息，避免与ProductAggregate强耦合
interface ProductSnapshot {
  id: string;
  price: number;
  stock: number;
}

interface OrderProps extends AggregateRootProps {
  userId: string;
  items: OrderItem[];
  status: OrderStatus;
  totalAmount: number;
}

// @ts-ignore : 让 OrderAggregate 能访问 OrderItem 的私有构造函数
export class OrderAggregate extends AggregateRoot {
  private props: OrderProps;

  private constructor(props: OrderProps) {
    super();
    this.props = props;
  }

  // 工厂方法：创建一个新的（空的）订单
  public static create(userId: string): OrderAggregate {
    return new OrderAggregate({
      userId,
      items: [],
      status: OrderStatus.DRAFT,
      totalAmount: 0,
      createdAt: new Date(),
      updatedAt: new Date(),
      id: randomUUID(),
    });
  }

  // 用于持久化
  public static reconstitute(props: OrderProps): OrderAggregate {
    return new OrderAggregate(props);
  }

  // 业务方法：添加商品
  public addItem(product: ProductSnapshot, quantity: number): void {
    if (this.props.status !== OrderStatus.DRAFT) {
      throw new Error(
        'Cannot add items to an order that is not in draft status.',
      );
    }
    if (product.stock < quantity) {
      throw new Error('Insufficient product stock.');
    }

    const existingItem = this.props.items.find(
      (item) => item.productId === product.id,
    );

    if (existingItem) {
      existingItem.increaseQuantity(quantity);
    } else {
      const newItem = OrderItem.create({
        productId: product.id,
        quantity: quantity,
        priceAtPurchase: product.price,
      });
      this.props.items.push(newItem);
    }

    this.recalculateTotal();
    this.props.updatedAt = new Date();
  }

  // 业务方法：标记为已支付（体现领域事件）
  public markAsPaid(): void {
    if (this.props.status !== OrderStatus.PENDING_PAYMENT) {
      throw new Error('Order is not pending payment.');
    }
    this.props.status = OrderStatus.PAID;
    this.props.updatedAt = new Date();

    // 关键！宣布“订单已支付”事件
    this.addDomainEvent(
      new OrderPaidEvent(
        this.id,
        this.userId,
        this.props.items.map((i) => ({
          productId: i.productId,
          quantity: i.quantity,
        })),
      ),
    );
  }

  // 其他状态流转...
  public confirmForPayment(): void {
    if (
      this.props.status !== OrderStatus.DRAFT ||
      this.props.items.length === 0
    ) {
      throw new Error('Draft order cannot be empty or is not in draft status.');
    }
    this.props.status = OrderStatus.PENDING_PAYMENT;
    this.props.updatedAt = new Date();
  }

  // 私有方法，保证数据一致性
  private recalculateTotal(): void {
    this.props.totalAmount = this.props.items.reduce(
      (sum, item) => sum + item.subTotal,
      0,
    );
  }

  // Getters
  public get id(): string {
    return this.props.id!;
  }
  public get userId(): string {
    return this.props.userId;
  }
  public get items(): readonly OrderItem[] {
    return this.props.items;
  }
  public get status(): OrderStatus {
    return this.props.status;
  }
  public get totalAmount(): number {
    return this.props.totalAmount;
  }
  public get updatedAt(): Date {
    return this.props.updatedAt!;
  }
}
