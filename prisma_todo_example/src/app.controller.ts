import {
  Body,
  Controller,
  Get,
  Param,
  Post,
  Redirect,
  Render,
} from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { AppService } from './app.service';
import { PlanService } from './plan/plan.service';

@ApiTags('app')
@Controller()
export class AppController {
  constructor(
    private readonly appService: AppService,
    private readonly planService: PlanService,
  ) {}

  /**
   * 渲染首页，显示所有计划
   * @returns {Promise<{ plans: any[] }>}
   */
  @Get()
  @Render('index')
  @ApiOperation({ summary: '获取所有计划列表' })
  async root() {
    const plans = await this.planService.findAllPlans();
    return { plans };
  }

  /**
   * 为特定计划创建一个新的 TODO 项
   * @param {string} planId - 计划的 ID
   * @param {{ title: string }} body - 请求体
   * @returns {void}
   */
  @Post('plans/:planId/todos')
  @Redirect()
  @ApiOperation({ summary: '为特定计划创建 TODO' })
  async createTodo(
    @Param('planId') planId: string,
    @Body() body: { title: string },
  ) {
    await this.appService.createTodo(body.title, Number(planId));
    // 重定向回计划详情页
    return { url: `/plans/${planId}` };
  }

  /**
   * 更新一个 TODO 项
   * @param {string} planId - 计划 ID (用于重定向)
   * @param {string} todoId - TODO 的 ID
   * @returns {void}
   */
  @Post('plans/:planId/todos/:todoId/complete')
  @Redirect()
  @ApiOperation({ summary: '将一个 TODO 项标记为已完成' })
  async updateTodo(
    @Param('planId') planId: string,
    @Param('todoId') todoId: string,
  ) {
    await this.appService.updateTodo(Number(todoId));
    return { url: `/plans/${planId}` };
  }

  /**
   * 删除一个 TODO 项
   * @param {string} planId - 计划 ID (用于重定向)
   * @param {string} todoId - TODO 的 ID
   * @returns {void}
   */
  @Post('plans/:planId/todos/:todoId/delete')
  @Redirect()
  @ApiOperation({ summary: '删除一个 TODO 项' })
  async deleteTodo(
    @Param('planId') planId: string,
    @Param('todoId') todoId: string,
  ) {
    await this.appService.deleteTodo(Number(todoId));
    return { url: `/plans/${planId}` };
  }
}
