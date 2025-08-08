import {
  Prisma,
  Order as PrismaOrder,
  OrderItem as PrismaOrderItem,
} from '@prisma/client';
import { OrderAggregate } from '../../domain/aggregates/order.aggregate-root';
import { OrderItem } from '../../domain/entities/order-item.entity';

// 定义一个包含关联关系的数据类型，方便查询
type OrderWithItems = PrismaOrder & {
  items: PrismaOrderItem[];
};

export class OrderPrismaMapper {
  static toDomain(prismaOrder: OrderWithItems): OrderAggregate {
    const domainItems = prismaOrder.items.map((item) =>
      OrderItem.create({
        productId: item.productId,
        quantity: item.quantity,
        priceAtPurchase: Number(item.priceAtPurchase),
      }),
    );

    return OrderAggregate.reconstitute({
      id: prismaOrder.id,
      userId: prismaOrder.userId,
      status: prismaOrder.status,
      totalAmount: Number(prismaOrder.totalAmount),
      createdAt: prismaOrder.createdAt,
      updatedAt: prismaOrder.updatedAt,
      items: domainItems,
    });
  }

  static toPersistence(order: OrderAggregate): {
    orderData: Prisma.OrderUncheckedCreateInput;
    itemsData: Array<{
      id: string;
      productId: string;
      quantity: number;
      priceAtPurchase: number;
    }>;
  } {
    const rawOrder = (order as any).props;

    return {
      orderData: {
        id: rawOrder.id,
        userId: rawOrder.userId,
        status: rawOrder.status,
        totalAmount: rawOrder.totalAmount,
        createdAt: rawOrder.createdAt,
        updatedAt: rawOrder.updatedAt,
      },
      itemsData: rawOrder.items.map((item: any) => {
        const rawItem = (item as any).props;
        return {
          id: rawItem.id,
          productId: rawItem.productId,
          quantity: rawItem.quantity,
          priceAtPurchase: rawItem.priceAtPurchase,
        };
      }),
    };
  }
}
