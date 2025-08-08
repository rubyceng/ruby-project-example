import { Module } from '@nestjs/common';
import { OrderPaidHandler } from './application/evnet-handle/order-paid.handler';
import { ProductService } from './application/services/product.service';
import { ProductController } from './controller/product.controller';
import { ProductRepository } from './domain/repositories/product.repository';
import { PrismaProductRepository } from './infrastructure/repositories/prisma-product.repository';
@Module({
  controllers: [ProductController],
  providers: [
    ProductService,
    // 这里是DI 依赖倒置的核心
    // 后续可以实现其他ORM
    {
      provide: ProductRepository,
      useClass: PrismaProductRepository,
    },
    OrderPaidHandler,
  ],
})
export class ProductModule {}
