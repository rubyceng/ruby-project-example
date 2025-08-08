import { IDomainEvent } from '@shared/domain/domain-event.base';
//领域事件包含需要传递的本领域信息，为只读属性
export class OrderPaidEvent implements IDomainEvent {
  public readonly dateTimeOccurred: Date;

  // 事件需要携带对其他模块有用的信息
  constructor(
    public readonly orderId: string,
    public readonly userId: string,
    public readonly itemIdsAndQuantities: {
      productId: string;
      quantity: number;
    }[],
  ) {
    this.dateTimeOccurred = new Date();
  }

  getAggregateId(): string {
    return this.orderId;
  }
}
