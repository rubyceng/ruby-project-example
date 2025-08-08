import { OrderAggregate } from '../../../modules/order/domain/aggregates/order.aggregate-root';

// 服务是纯粹的，它不注入任何东西，只接收领域对象作为参数，并返回计算结果。它的方法是无状态的

// 定义折扣结果的数据结构
export interface DiscountResult {
  discountAmount: number;
  description: string;
}

// SKU常量，实际项目中应来自配置或数据库
const COKE_SKU = 'COKE-500';
const LAYS_SKU = 'LAYS-CLASSIC';

export class DiscountService {
  /**
   * 计算适用于订单的折扣
   * @param order 订单聚合根
   * @param productsInOrder 一个包含订单中所有商品聚合根的Map，由应用层传入
   * @returns 如果有折扣则返回DiscountResult，否则返回null
   */
  public calculateBundleDiscount(
    order: OrderAggregate,
    productsInOrder: Map<string, { sku: string }>,
  ): DiscountResult | null {
    const hasCoke = order.items.some(
      (item) => productsInOrder.get(item.productId)?.sku === COKE_SKU,
    );

    const hasLays = order.items.some(
      (item) => productsInOrder.get(item.productId)?.sku === LAYS_SKU,
    );

    // 核心业务规则：如果同时包含可乐和薯片
    if (hasCoke && hasLays) {
      console.log(
        '[DomainService] "快乐套餐" a discount condition has been met!',
      );

      const originalTotal = order.totalAmount;
      const discountAmount = originalTotal * 0.1; // 10% discount

      return {
        discountAmount: parseFloat(discountAmount.toFixed(2)), // toFixed(2) to avoid floating point issues
        description: '快乐套餐9折优惠',
      };
    }

    return null;
  }
}
