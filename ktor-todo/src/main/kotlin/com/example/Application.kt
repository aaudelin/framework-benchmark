package com.example

import io.ktor.server.application.*
import io.ktor.server.engine.*
import io.ktor.server.netty.*
import io.ktor.server.plugins.contentnegotiation.*
import io.ktor.serialization.kotlinx.json.*
import io.ktor.server.routing.*
import io.ktor.server.response.*
import io.ktor.server.request.*
import io.ktor.http.*
import kotlinx.serialization.Serializable
import java.util.concurrent.atomic.AtomicInteger

@Serializable
data class Task(
    val id: Int,
    val name: String,
    val description: String
)

@Serializable
data class TaskInput(
    val name: String,
    val description: String
)

val tasks = mutableListOf<Task>()
val nextId = AtomicInteger(1)

fun main() {
    embeddedServer(Netty, port = 8081) {
        install(ContentNegotiation) {
            json()
        }

        routing {
            // API routes
            route("/api/tasks") {
                get {
                    call.respond(tasks)
                }

                post {
                    val input = call.receive<TaskInput>()
                    val task = Task(
                        id = nextId.getAndIncrement(),
                        name = input.name,
                        description = input.description
                    )
                    tasks.add(task)
                    call.respond(HttpStatusCode.Created, task)
                }

                delete("/{id}") {
                    val id = call.parameters["id"]?.toIntOrNull()
                    if (id != null) {
                        tasks.removeIf { it.id == id }
                        call.respond(HttpStatusCode.NoContent)
                    } else {
                        call.respond(HttpStatusCode.BadRequest)
                    }
                }
            }

            // Serve static files
            staticResources("/", "static")
        }
    }.start(wait = true)
}
