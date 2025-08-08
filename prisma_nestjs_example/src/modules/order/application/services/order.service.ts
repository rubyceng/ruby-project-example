import { Inject, Injectable, NotFoundException } from '@nestjs/common';
import { ProductRepository } from '../../../product/domain/repositories/product.repository';
import { OrderAggregate } from '../../domain/aggregates/order.aggregate-root';
import { OrderRepository } from '../../domain/repositories/order.repository';
import { ComplexOrderValidationService } from '../../domain/service/complex-order-validation.service';
import { AddItemDto } from '../dtos/add-item.dto';
import { OrderVo } from '../dtos/vo/order.vo';
import { OrderMapper } from '../mappers/order.mapper';
//订单服务 服务层始终只会操作 领域聚合根的方法和调用Repository进行持久化
@Injectable()
export class OrderService {
  // 依赖倒置
  constructor(
    @Inject(OrderRepository)
    private readonly orderRepository: OrderRepository,
    @Inject(ProductRepository)
    private readonly productRepository: ProductRepository,
  ) {}

  // 用例1: 添加商品到购物车（即草稿状态的订单）
  async addItemToCart(
    userId: string,
    addItemDto: AddItemDto,
  ): Promise<OrderVo> {
    // 1. 查找商品，并检查是否存在
    const product = await this.productRepository.findById(addItemDto.productId);
    if (!product) {
      throw new NotFoundException(
        `Product with ID ${addItemDto.productId} not found.`,
      );
    }

    // 2. 查找用户的草稿订单，如果不存在就创建一个新的
    let cart = await this.orderRepository.findDraftByUserId(userId);
    if (!cart) {
      cart = OrderAggregate.create(userId);
    }

    // 3. 调用领域方法来添加商品（所有业务规则都在聚合内部）
    cart.addItem(
      { id: product.id, price: product.price, stock: product.stock },
      addItemDto.quantity,
    );

    // 4. 持久化聚合的变更
    await this.orderRepository.save(cart);

    // 5. 转换为 VO 返回
    return OrderMapper.toVo(cart);
  }

  // 用例2：获取用户的购物车
  async getCart(userId: string): Promise<OrderVo | null> {
    const cart = await this.orderRepository.findDraftByUserId(userId);
    return cart ? OrderMapper.toVo(cart) : null;
  }

  // 用例3：确认订单，准备支付
  async confirmOrder(userId: string): Promise<OrderVo> {
    const cart = await this.orderRepository.findDraftByUserId(userId);
    if (!cart) {
      throw new NotFoundException('Cart not found for user.');
    }

    const validationService = new ComplexOrderValidationService();
    // 处理产品和用户信息
    // const products = await this.productRepository.findByIds(
    //   cart.items.map((item) => item.productId),
    // );
    // const customer = await this.userRepository.findById(userId);

    const validationResult = validationService.validateForSubmission(
      cart,
      { isVip: true },
      [
        {
          isLuxury: true,
        },
      ],
    );

    if (validationResult.requiresManualReview) {
      // cart.markForManualReview();
      // 需要人工审核
      // 1. 发送审核请求
      // 2. 等待审核结果
      // 3. 根据审核结果更新订单状态
      // 4. 发送审核结果通知
      // 5. 更新订单状态
      // 6. 发送订单状态更新通知
    } else {
    }

    cart.confirmForPayment();

    await this.orderRepository.save(cart);

    return OrderMapper.toVo(cart);
  }
}
