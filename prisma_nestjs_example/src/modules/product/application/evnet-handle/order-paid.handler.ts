import { Inject, Injectable } from '@nestjs/common';
import { OnEvent } from '@nestjs/event-emitter';
import { OrderPaidEvent } from '../../../order/domain/events/order-paid.event';
import { ProductRepository } from '../../domain/repositories/product.repository';

@Injectable()
export class OrderPaidHandler {
  constructor(
    @Inject(ProductRepository)
    private readonly productRepository: ProductRepository,
  ) {}

  // 监听 OrderPaidEvent
  @OnEvent(OrderPaidEvent.name)
  async handleOrderPaidEvent(event: OrderPaidEvent) {
    console.log(
      `[EVENT] Order ${event.orderId} paid. Preparing to decrease stock.`,
    );

    // 异步处理每个商品的库存扣减
    for (const item of event.itemIdsAndQuantities) {
      try {
        const product = await this.productRepository.findById(item.productId);
        if (product) {
          product.decreaseStock(item.quantity);
          await this.productRepository.save(product);
          console.log(
            `[STOCK] Decreased stock for product ${item.productId} by ${item.quantity}.`,
          );
        }
      } catch (error) {
        // 在真实项目中，这里需要有重试或记录失败的逻辑
        console.error(
          `[ERROR] Failed to decrease stock for product ${item.productId}:`,
          error,
        );
      }
    }
  }
}
