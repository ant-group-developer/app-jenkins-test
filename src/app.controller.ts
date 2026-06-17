import { Controller, Get } from '@nestjs/common';
import { AppService } from './app.service';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) { }

  @Get()
  getHello(): string {
    return this.appService.getHello();
  }

  @Get('/ping')
  ping() {
    return this.appService.ping();
  }

  @Get('/healthz/details')
  getHealthDetails() {
    return this.appService.getHealthDetails();
  }

  @Get('/version')
  getVersion() {
    return {
      app: 'app-jenkins-test',
      build: process.env.BUILD_ID || 'local',
      commit: process.env.GIT_COMMIT || 'unknown',
    };
  }
}
