import { IDomainEvent } from './domain-event.base';
// 聚合根基类
// 聚合根(Aggregate Root)绝对、绝对不能，在任何情况下，调用一个仓储(Repository)。
export interface AggregateRootProps {
  id?: string;
  createdAt?: Date;
  updatedAt?: Date;
}
export abstract class AggregateRoot {
  private _domainEvents: IDomainEvent[] = [];
  public get domainEvents(): IDomainEvent[] {
    return this._domainEvents;
  }

  protected addDomainEvent(domainEvent: IDomainEvent): void {
    this._domainEvents.push(domainEvent);
  }

  public clearDomainEvents(): void {
    this._domainEvents = [];
  }
  // 创建聚合根 - 子类必须重写
  public static create(props: any): AggregateRoot {
    throw new Error(`${this.name}.create() must be implemented`);
  }

  // POJO再水合 - 子类必须重写
  // 恢复聚合根
  public static reconstitute(props: any): AggregateRoot {
    throw new Error(`${this.name}.reconstitute() must be implemented`);
  }
}
