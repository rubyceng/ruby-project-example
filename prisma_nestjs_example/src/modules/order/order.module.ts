import { Module } from '@nestjs/common';
import { ProductRepository } from '../product/domain/repositories/product.repository';
import { PrismaProductRepository } from '../product/infrastructure/repositories/prisma-product.repository';
import { OrderService } from './application/services/order.service';
import { OrderController } from './controller/order.controller';
import { OrderRepository } from './domain/repositories/order.repository';
import { PrismaOrderRepository } from './infrastructure/repositories/prisma-order.repository';

@Module({
  controllers: [OrderController],
  providers: [
    OrderService,
    // 依赖倒置：为 OrderRepository 接口提供 Prisma 的具体实现
    {
      provide: OrderRepository,
      useClass: PrismaOrderRepository,
    },
    // 模块间可以有依赖，但依赖的是抽象（接口），而不是具体实现。
    {
      provide: ProductRepository,
      useClass: PrismaProductRepository,
    },
  ],
})
export class OrderModule {}
