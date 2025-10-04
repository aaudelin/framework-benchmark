package com.example.todo

import org.springframework.stereotype.Service
import java.util.concurrent.atomic.AtomicInteger

@Service
class TaskService {
    private val tasks = mutableListOf<Task>()
    private val nextId = AtomicInteger(1)

    fun findAll(): List<Task> = tasks.toList()

    fun create(input: TaskInput): Task {
        val task = Task(
            id = nextId.getAndIncrement(),
            name = input.name,
            description = input.description
        )
        tasks.add(task)
        return task
    }

    fun delete(id: Int) {
        tasks.removeIf { it.id == id }
    }
}
