package com.example.todo

data class Task(
    val id: Int,
    val name: String,
    val description: String
)

data class TaskInput(
    val name: String,
    val description: String
)
