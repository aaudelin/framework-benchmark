import { Injectable } from '@nestjs/common';
import { Task } from './task.interface';

@Injectable()
export class TaskService {
  private tasks: Task[] = [];
  private nextId = 1;

  findAll(): Task[] {
    return this.tasks;
  }

  create(name: string, description: string): Task {
    const task: Task = {
      id: this.nextId++,
      name,
      description,
    };
    this.tasks.push(task);
    return task;
  }

  delete(id: number): void {
    this.tasks = this.tasks.filter(task => task.id !== id);
  }
}
