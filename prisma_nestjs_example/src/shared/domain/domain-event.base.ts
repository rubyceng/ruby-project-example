// 领域事件接口
export interface IDomainEvent {
  /**事件发生时间 */
  dateTimeOccurred: Date;
  /**获取聚合根ID */
  getAggregateId(): string;
}
