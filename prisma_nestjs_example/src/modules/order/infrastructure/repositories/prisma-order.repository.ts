import { Injectable } from '@nestjs/common';
import { EventEmitter2 } from '@nestjs/event-emitter';
import { OrderStatus } from '@prisma/client';
import { PrismaService } from '../../../../shared/infrastructure/prisma/prisma.service';
import { OrderAggregate } from '../../domain/aggregates/order.aggregate-root';
import { OrderRepository } from '../../domain/repositories/order.repository';
import { OrderPrismaMapper } from '../mappers/order.prisma-mapper';

@Injectable()
export class PrismaOrderRepository implements OrderRepository {
  // 定义一个标准的 include 查询，确保每次都能带出订单项
  private readonly includeClause = { items: true };

  constructor(
    private readonly prisma: PrismaService,
    private readonly eventEmitter: EventEmitter2,
  ) {}

  async save(order: OrderAggregate): Promise<void> {
    const { orderData, itemsData } = OrderPrismaMapper.toPersistence(order);

    // 使用事务来保证订单头和订单项的一致性
    await this.prisma.$transaction(async (tx) => {
      await tx.order.upsert({
        where: { id: order.id },
        create: {
          id: orderData.id,
          userId: orderData.userId,
          status: orderData.status,
          totalAmount: orderData.totalAmount,
          createdAt: orderData.createdAt,
          updatedAt: orderData.updatedAt,
        },
        update: {
          status: orderData.status,
          totalAmount: orderData.totalAmount,
          updatedAt: orderData.updatedAt,
        },
        include: this.includeClause,
      });

      if (itemsData.length > 0) {
        // 获取当前订单的所有项目ID
        const currentItemIds = itemsData.map((item) => item.id);

        // 删除不在当前列表中的项目
        await tx.orderItem.deleteMany({
          where: {
            orderId: orderData.id,
            id: { notIn: currentItemIds },
          },
        });

        for (const item of itemsData) {
          await tx.orderItem.upsert({
            where: { id: item.id },
            create: {
              id: item.id,
              productId: item.productId,
              quantity: item.quantity,
              priceAtPurchase: item.priceAtPurchase,
              orderId: orderData.id,
            },
            update: {
              quantity: item.quantity,
              priceAtPurchase: item.priceAtPurchase,
            },
          });
        }
      } else {
        // 如果没有项目，删除所有现有项目
        await tx.orderItem.deleteMany({
          where: { orderId: orderData.id },
        });
      }

      // 分发领域事件
      order.domainEvents.forEach((event) => {
        this.eventEmitter.emit(event.constructor.name, event);
      });

      // 清除领域事件，防止重复分发
      order.clearDomainEvents();
    });
  }

  async findById(id: string): Promise<OrderAggregate | null> {
    const prismaOrder = await this.prisma.order.findUnique({
      where: { id },
      include: this.includeClause,
    });
    return prismaOrder ? OrderPrismaMapper.toDomain(prismaOrder) : null;
  }

  async findDraftByUserId(userId: string): Promise<OrderAggregate | null> {
    const prismaOrder = await this.prisma.order.findFirst({
      where: { userId, status: OrderStatus.DRAFT },
      include: this.includeClause,
    });
    return prismaOrder ? OrderPrismaMapper.toDomain(prismaOrder) : null;
  }
}
