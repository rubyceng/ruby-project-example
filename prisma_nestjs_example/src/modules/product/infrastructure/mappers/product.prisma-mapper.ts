import { Prisma, Product } from '@prisma/client';
import {
  ProductAggregate,
  ProductProps,
} from '../../domain/aggregates/product.aggregate-root';

export class ProductPrismaMapper {
  static toDomain(prismaProduct: Product): ProductAggregate {
    const props: ProductProps = {
      id: prismaProduct.id,
      name: prismaProduct.name,
      description: prismaProduct.description,
      price: Number(prismaProduct.price),
      sku: prismaProduct.sku,
      stock: prismaProduct.stock,
      createdAt: prismaProduct.createdAt,
      updatedAt: prismaProduct.updatedAt,
    };
    return ProductAggregate.reconstitute(props);
  }

  static toPersistence(
    product: ProductAggregate,
  ): Prisma.ProductUncheckedCreateInput {
    const raw = ProductAggregate.toRaw(product);
    return {
      id: raw.id,
      name: raw.name,
      description: raw.description,
      price: raw.price,
      sku: raw.sku,
      stock: raw.stock,
      createdAt: raw.createdAt,
      updatedAt: raw.updatedAt,
    };
  }
}
