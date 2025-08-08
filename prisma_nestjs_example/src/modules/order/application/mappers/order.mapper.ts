import { OrderAggregate } from '../../domain/aggregates/order.aggregate-root';
import { OrderVo } from '../dtos/vo/order.vo';

export class OrderMapper {
  static toVo(order: OrderAggregate): OrderVo {
    return {
      id: order.id,
      userId: order.userId,
      status: order.status,
      totalAmount: order.totalAmount,
      updatedAt: order.updatedAt,
      items: order.items.map((item) => ({
        id: item.id,
        productId: item.productId,
        quantity: item.quantity,
        priceAtPurchase: item.priceAtPurchase,
        subTotal: item.subTotal,
      })),
    };
  }
}
