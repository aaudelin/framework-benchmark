import { Controller, Get, Post, Delete, Body, Param } from '@nestjs/common';
import { TaskService } from './task.service';
import { Task } from './task.interface';

@Controller('api/tasks')
export class TaskController {
  constructor(private readonly taskService: TaskService) {}

  @Get()
  findAll(): Task[] {
    return this.taskService.findAll();
  }

  @Post()
  create(@Body() body: { name: string; description: string }): Task {
    return this.taskService.create(body.name, body.description);
  }

  @Delete(':id')
  delete(@Param('id') id: string): void {
    this.taskService.delete(parseInt(id, 10));
  }
}
