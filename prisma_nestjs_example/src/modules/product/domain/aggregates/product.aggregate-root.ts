import { randomUUID } from 'crypto';
import {
  AggregateRoot,
  AggregateRootProps,
} from '../../../../shared/domain/aggregate-root.base';

export interface ProductProps extends AggregateRootProps {
  name: string;
  description?: string | null;
  price: number;
  sku: string;
  stock: number;
}

export class ProductAggregate extends AggregateRoot {
  private props: ProductProps;

  private constructor(props: ProductProps) {
    super();
    this.props = props;
  }

  // 工厂方法，用于创建新的 Product 实例，保证不变量
  public static create(props: ProductProps): ProductAggregate {
    if (props.price < 0) {
      throw new Error('Product price cannot be negative.');
    }
    if (props.stock < 0) {
      throw new Error('Product stock cannot be negative.');
    }
    if (!props.name.trim()) {
      throw new Error('Product name cannot be empty.');
    }
    if (!props.sku.trim()) {
      throw new Error('Product SKU cannot be empty.');
    }

    // 设置属性
    const product = {
      ...props,
      id: randomUUID(),
      createdAt: new Date(),
      updatedAt: new Date(),
    };

    return new ProductAggregate(product);
  }

  public static reconstitute(props: ProductProps): ProductAggregate {
    return new ProductAggregate(props);
  }

  // 业务方法：更新价格
  public updatePrice(newPrice: number): void {
    if (newPrice < 0) {
      throw new Error('Product price cannot be negative.');
    }
    this.props.price = newPrice;
    this.props.updatedAt = new Date();
  }

  // 业务方法：减少库存
  public decreaseStock(quantity: number): void {
    if (this.props.stock < quantity) {
      throw new Error('Insufficient stock.');
    }
    this.props.stock -= quantity;
    this.props.updatedAt = new Date();
  }

  // Getter 方法，用于访问属性
  public get id(): string {
    return this.props.id!;
  }
  public get name(): string {
    return this.props.name;
  }
  public get description(): string | null {
    return this.props.description || null;
  }
  public get price(): number {
    return this.props.price;
  }
  public get sku(): string {
    return this.props.sku;
  }
  public get stock(): number {
    return this.props.stock;
  }
  public get createdAt(): Date {
    return this.props.createdAt!;
  }
  public get updatedAt(): Date {
    return this.props.updatedAt!;
  }

  // 用于持久化或映射
  public static toRaw(product: ProductAggregate): ProductProps {
    return product.props;
  }
}
