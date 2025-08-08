import { ProductAggregate } from '../../domain/aggregates/product.aggregate-root';
import { ProductVo } from '../dtos/vo/product.vo';

export class ProductMapper {
  static toVo(product: ProductAggregate): ProductVo {
    return {
      id: product.id,
      name: product.name,
      description: product.description,
      price: product.price,
      sku: product.sku,
      stock: product.stock,
      createdAt: product.createdAt,
    };
  }
}
