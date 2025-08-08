import {
  ConflictException,
  Inject,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { ProductAggregate } from '../../domain/aggregates/product.aggregate-root';
import { ProductRepository } from '../../domain/repositories/product.repository';
import { CreateProductDto } from '../dtos/create-product.dto';
import { ProductVo } from '../dtos/vo/product.vo';
import { ProductMapper } from '../mappers/product.mapper';

@Injectable()
export class ProductService {
  // 使用 @Inject 手动注入接口，因为它是抽象类
  constructor(
    @Inject(ProductRepository)
    private readonly productRepository: ProductRepository,
  ) {}

  async create(createProductDto: CreateProductDto): Promise<ProductVo> {
    // 检查SKU是否已存在
    const existingProduct = await this.productRepository.findBySku(
      createProductDto.sku,
    );
    if (existingProduct) {
      throw new ConflictException(
        `Product with SKU ${createProductDto.sku} already exists.`,
      );
    }

    // 使用工厂方法创建聚合根
    const product = ProductAggregate.create({
      name: createProductDto.name,
      price: createProductDto.price,
      sku: createProductDto.sku,
      stock: createProductDto.stock,
      description: createProductDto.description,
    });

    // 通过仓储持久化
    await this.productRepository.save(product);

    // 使用 mapper 转换为 DTO 返回
    return ProductMapper.toVo(product);
  }

  async findOne(id: string): Promise<ProductVo> {
    const product = await this.productRepository.findById(id);
    if (!product) {
      throw new NotFoundException(`Product with ID ${id} not found.`);
    }
    return ProductMapper.toVo(product);
  }

  async findAll(): Promise<ProductVo[]> {
    const products = await this.productRepository.findAll();
    return products.map(ProductMapper.toVo);
  }
}
