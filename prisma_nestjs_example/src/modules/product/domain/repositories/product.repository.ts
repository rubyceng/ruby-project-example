import { ProductAggregate } from '../aggregates/product.aggregate-root';

export abstract class ProductRepository {
  abstract save(product: ProductAggregate): Promise<void>;
  abstract findById(id: string): Promise<ProductAggregate | null>;
  abstract findBySku(sku: string): Promise<ProductAggregate | null>;
  abstract findAll(): Promise<ProductAggregate[]>;
}
