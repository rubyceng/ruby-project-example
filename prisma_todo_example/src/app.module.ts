import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { PlanModule } from './plan/plan.module';
import { PrismaService } from './prisma.service';

@Module({
  imports: [PlanModule],
  controllers: [AppController],
  providers: [AppService, PrismaService],
})
export class AppModule {}
