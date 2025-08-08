import {
  Body,
  Controller,
  Get,
  Param,
  Post,
  Redirect,
  Render,
} from '@nestjs/common';
import { ApiBody, ApiOperation, ApiParam, ApiTags } from '@nestjs/swagger';
import { PlanService } from './plan.service';

@ApiTags('plans')
@Controller('plans')
export class PlanController {
  constructor(private readonly planService: PlanService) {}

  /**
   * 显示创建新计划的表单页面 (此功能为了完整性，但在当前UI中未直接使用)
   * @returns
   */
  @Get('new')
  @Render('plan-new')
  showNewPlanForm() {
    return {};
  }

  /**
   * 创建一个新的计划
   * @param {{ name: string }} body - 请求体，包含 name
   * @returns {void}
   */
  @Post()
  @Redirect('/') // 创建后重定向到首页
  @ApiOperation({ summary: '创建一个新的计划' })
  @ApiBody({
    schema: {
      type: 'object',
      properties: {
        name: {
          type: 'string',
          example: '我的购物清单',
          description: '计划的名称',
        },
      },
    },
  })
  async createPlan(@Body() body: { name: string }) {
    await this.planService.createPlan(body.name);
  }

  /**
   * 显示特定计划及其下的所有 TODO
   * @param {string} id - 计划的 ID
   * @returns {Promise<{ plan: any }>}
   */
  @Get(':id')
  @Render('plan-detail')
  @ApiOperation({ summary: '获取特定计划的详情' })
  @ApiParam({ name: 'id', description: '计划的 ID' })
  async getPlan(@Param('id') id: string) {
    const plan = await this.planService.findPlanById(Number(id));
    return { plan };
  }
}
