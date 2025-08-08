import { Injectable } from '@nestjs/common';
import { Plan } from '@prisma/client';
import { PrismaService } from '../prisma.service';

@Injectable()
export class PlanService {
  constructor(private readonly prisma: PrismaService) {}

  /**
   * 创建一个新的计划
   * @param {string} name - 计划的名称
   * @returns {Promise<Plan>}
   */
  async createPlan(name: string): Promise<Plan> {
    return this.prisma.plan.create({
      data: { name },
    });
  }

  /**
   * 获取所有计划
   * @returns {Promise<Plan[]>}
   */
  async findAllPlans(): Promise<Plan[]> {
    return this.prisma.plan.findMany();
  }

  /**
   * 根据 ID 查找一个计划，并包含其下的所有 TODO
   * @param {number} id - 计划的 ID
   * @returns {Promise<Plan & { todos: Todo[] }>}
   */
  async findPlanById(id: number) {
    return this.prisma.plan.findUnique({
      where: { id },
      include: {
        todos: true, // 在查询 Plan 的同时，把关联的 todos 也一并查出来
      },
    });
  }
}
