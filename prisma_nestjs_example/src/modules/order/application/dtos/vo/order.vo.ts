import { OrderStatus } from '@prisma/client';

interface OrderItemVo {
  id: string;
  productId: string;
  quantity: number;
  priceAtPurchase: number;
  subTotal: number;
}

export class OrderVo {
  id: string;
  userId: string;
  items: OrderItemVo[];
  status: OrderStatus;
  totalAmount: number;
  updatedAt: Date;
}
