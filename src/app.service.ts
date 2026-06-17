import { Injectable } from '@nestjs/common';

@Injectable()
export class AppService {
  getHello(): string {
    return 'Hello World!';
  }

  ping() {
    return {
      status: 'ok',
      uptime: process.uptime(),
      timestamp: Date.now(),
    };
  }

  getHealthDetails() {
    return {
      status: 'ok',
      service: 'app-jenkins-test',
      uptime: process.uptime(),
      memory: process.memoryUsage(),
      nodeVersion: process.version,
      platform: process.platform,
      timestamp: new Date().toISOString(),
    };
  }
}
