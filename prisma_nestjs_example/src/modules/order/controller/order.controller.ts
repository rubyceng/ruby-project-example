import {
  Body,
  Controller,
  Get,
  NotFoundException,
  Param,
  ParseUUIDPipe,
  Patch,
  Post,
} from '@nestjs/common';
import { AddItemDto } from '../application/dtos/add-item.dto';
import { OrderMapper } from '../application/mappers/order.mapper';
import { OrderService } from '../application/services/order.service';
import { OrderRepository } from '../domain/repositories/order.repository';

// 假设这是从JWT或Session中获取的用户ID
// 在真实项目中，这里会是一个 @User() user.id 的装饰器
const MOCK_USER_ID = '00000000-0000-0000-0000-000000000001';

@Controller('orders')
export class OrderController {
  constructor(
    private readonly orderService: OrderService,
    private readonly orderRepository: OrderRepository,
  ) {}

  /**
   * @description 添加商品到当前用户的购物车(草稿订单)
   */
  @Post('/cart/items')
  addItemToCart(@Body() addItemDto: AddItemDto) {
    // 在真实应用中，userId 来自认证守卫
    const userId = MOCK_USER_ID;
    return this.orderService.addItemToCart(userId, addItemDto);
  }

  /**
   * @description 获取当前用户的购物车
   */
  @Get('/cart')
  getCart() {
    const userId = MOCK_USER_ID;
    return this.orderService.getCart(userId);
  }

  /**
   * @description 确认购物车为订单，准备支付
   */
  @Patch('/cart/confirm')
  confirmOrder() {
    const userId = MOCK_USER_ID;
    return this.orderService.confirmOrder(userId);
  }

  // 模拟回调
  @Patch(':id/test-pay')
  async testPay(@Param('id', ParseUUIDPipe) id: string) {
    const order = await this.orderRepository.findById(id); // 直接用仓储，仅为测试
    if (!order) throw new NotFoundException();

    order.markAsPaid();
    await this.orderRepository.save(order);

    return OrderMapper.toVo(order);
  }

  // 可以在这里添加更多端点，比如获取历史订单列表，获取订单详情等
  // GET /:id  - 获取特定订单详情
  // GET /     - 获取当前用户的所有历史订单 (非草稿状态)
}
