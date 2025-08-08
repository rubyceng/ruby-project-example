import { Injectable } from '@nestjs/common';
import { Todo } from '@prisma/client';
import { PrismaService } from './prisma.service';

@Injectable()
export class AppService {
  constructor(private readonly prisma: PrismaService) {}

  /**
   * 为指定的计划创建一个新的 TODO 项
   * @param {string} title - TODO 项的标题
   * @param {number} planId - 关联的计划 ID
   * @returns {Promise<Todo>}
   */
  async createTodo(title: string, planId: number): Promise<Todo> {
    return this.prisma.todo.create({
      data: {
        title,
        planId,
      },
    });
  }

  /**
   * 更新一个 TODO 项的状态
   * @param {number} id - TODO 项的 ID
   * @returns {Promise<Todo>}
   */
  async updateTodo(id: number): Promise<Todo> {
    return this.prisma.todo.update({
      where: { id },
      data: {
        isCompleted: true,
      },
    });
  }

  /**
   * 删除一个 TODO 项
   * @param {number} id - TODO 项的 ID
   * @returns {Promise<Todo>}
   */
  async deleteTodo(id: number): Promise<Todo> {
    return this.prisma.todo.delete({
      where: { id },
    });
  }
}
