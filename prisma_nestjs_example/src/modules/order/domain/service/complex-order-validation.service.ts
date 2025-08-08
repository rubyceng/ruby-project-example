import { OrderAggregate } from '../aggregates/order.aggregate-root';

// 订单领域服务
export class ComplexOrderValidationService {
  public validateForSubmission(
    order: OrderAggregate,
    customer: { isVip: boolean },
    products: Array<{ isLuxury: boolean }>,
  ): { requiresManualReview: boolean } {
    if (customer.isVip) {
      return { requiresManualReview: false };
    }

    const hasLuxuryGoods = products.some((p) => p.isLuxury);
    if (order.totalAmount > 5000 || hasLuxuryGoods) {
      // ... 执行复杂的验证逻辑 ...
      return { requiresManualReview: true };
    }

    return { requiresManualReview: false };
  }
}
