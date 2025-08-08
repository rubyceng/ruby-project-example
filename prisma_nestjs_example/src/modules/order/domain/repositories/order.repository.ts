import { OrderAggregate } from '../aggregates/order.aggregate-root';
// 订单仓储接口
export abstract class OrderRepository {
  /**保存订单 */
  abstract save(order: OrderAggregate): Promise<void>;
  /**根据ID查询订单 */
  abstract findById(id: string): Promise<OrderAggregate | null>;
  /**根据用户ID查询购物车 */
  abstract findDraftByUserId(userId: string): Promise<OrderAggregate | null>;
}
