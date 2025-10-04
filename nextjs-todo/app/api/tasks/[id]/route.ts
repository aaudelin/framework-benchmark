import { NextResponse } from 'next/server';
import { removeTasks } from '../route';

export async function DELETE(
  request: Request,
  { params }: { params: Promise<{ id: string }> }
) {
  const { id } = await params;
  const taskId = parseInt(id, 10);
  removeTasks(taskId);
  return new NextResponse(null, { status: 204 });
}
