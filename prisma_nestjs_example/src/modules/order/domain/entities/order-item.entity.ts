import { randomUUID } from 'crypto';

interface OrderItemProps {
  id?: string;
  productId: string;
  quantity: number;
  priceAtPurchase: number;
}

export class OrderItem {
  private props: OrderItemProps;

  private constructor(props: OrderItemProps) {
    this.props = { ...props, id: props.id || randomUUID() };
  }

  public static create(props: Omit<OrderItemProps, 'id'>): OrderItem {
    if (props.quantity <= 0) {
      throw new Error('Quantity must be greater than zero.');
    }
    return new OrderItem(props);
  }

  public get id(): string {
    return this.props.id!;
  }
  public get productId(): string {
    return this.props.productId;
  }
  public get quantity(): number {
    return this.props.quantity;
  }
  public get priceAtPurchase(): number {
    return this.props.priceAtPurchase;
  }

  public get subTotal(): number {
    return this.props.quantity * this.props.priceAtPurchase;
  }

  public increaseQuantity(amount: number): void {
    if (amount <= 0) throw new Error('Amount must be positive.');
    this.props.quantity += amount;
  }
}
