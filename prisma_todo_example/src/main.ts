import { NestFactory } from '@nestjs/core';
import { NestExpressApplication } from '@nestjs/platform-express';
import { join } from 'path';
import { AppModule } from './app.module';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';

async function bootstrap() {
  const app = await NestFactory.create<NestExpressApplication>(AppModule);

  // 配置静态资源路径
  app.useStaticAssets(join(__dirname, '..', 'public'));
  // 配置视图路径
  app.setBaseViewsDir(join(__dirname, '..', 'views'));
  // 配置视图引擎
  app.setViewEngine('ejs');

  // 配置 Swagger
  const config = new DocumentBuilder()
    .setTitle('Todo App')
    .setDescription('The Todo App API description')
    .setVersion('1.0')
    .addTag('todos')
    .build();
  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('api', app, document);

  await app.listen(3000);
}
bootstrap();
