import { NextResponse } from 'next/server';

interface Task {
  id: number;
  name: string;
  description: string;
}

export let tasks: Task[] = [];
export let nextId = 1;

export async function GET() {
  return NextResponse.json(tasks);
}

export async function POST(request: Request) {
  const { name, description } = await request.json();
  const task: Task = {
    id: nextId++,
    name,
    description,
  };
  tasks.push(task);
  return NextResponse.json(task, { status: 201 });
}

export function removeTasks(id: number) {
  tasks = tasks.filter(task => task.id !== id);
}
