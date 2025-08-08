import { Module } from '@nestjs/common';
import { EventEmitterModule } from '@nestjs/event-emitter';
import { OrderModule } from './modules/order/order.module';
import { ProductModule } from './modules/product/product.module';
import { PrismaModule } from './shared/infrastructure/prisma/prisma.module';

@Module({
  imports: [
    PrismaModule,
    ProductModule,
    OrderModule,
    EventEmitterModule.forRoot({
      global: true,
    }),
  ],
  controllers: [],
  providers: [],
})
export class AppModule {}
