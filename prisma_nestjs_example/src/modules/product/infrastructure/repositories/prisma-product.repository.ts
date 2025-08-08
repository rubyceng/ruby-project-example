import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../../../shared/infrastructure/prisma/prisma.service';
import { ProductAggregate } from '../../domain/aggregates/product.aggregate-root';
import { ProductRepository } from '../../domain/repositories/product.repository';
import { ProductPrismaMapper } from '../mappers/product.prisma-mapper';

@Injectable()
export class PrismaProductRepository implements ProductRepository {
  constructor(private readonly prisma: PrismaService) {}

  async save(product: ProductAggregate): Promise<void> {
    const persistenceData = ProductPrismaMapper.toPersistence(product);
    await this.prisma.product.upsert({
      where: { id: product.id },
      update: persistenceData,
      create: persistenceData,
    });
  }

  async findById(id: string): Promise<ProductAggregate | null> {
    const prismaProduct = await this.prisma.product.findUnique({
      where: { id },
    });
    return prismaProduct ? ProductPrismaMapper.toDomain(prismaProduct) : null;
  }

  async findBySku(sku: string): Promise<ProductAggregate | null> {
    const prismaProduct = await this.prisma.product.findUnique({
      where: { sku },
    });
    return prismaProduct ? ProductPrismaMapper.toDomain(prismaProduct) : null;
  }

  async findAll(): Promise<ProductAggregate[]> {
    const prismaProducts = await this.prisma.product.findMany();
    return prismaProducts.map(ProductPrismaMapper.toDomain);
  }
}
