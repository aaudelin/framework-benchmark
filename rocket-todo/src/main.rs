#[macro_use]
extern crate rocket;

use rocket::fs::{FileServer, relative};
use rocket::serde::{json::Json, Deserialize, Serialize};
use rocket::State;
use std::sync::Mutex;

#[derive(Debug, Clone, Serialize, Deserialize)]
struct Task {
    id: u32,
    name: String,
    description: String,
}

#[derive(Debug, Deserialize)]
struct TaskInput {
    name: String,
    description: String,
}

struct AppState {
    tasks: Mutex<Vec<Task>>,
    next_id: Mutex<u32>,
}

#[get("/api/tasks")]
fn get_tasks(state: &State<AppState>) -> Json<Vec<Task>> {
    let tasks = state.tasks.lock().unwrap();
    Json(tasks.clone())
}

#[post("/api/tasks", format = "json", data = "<input>")]
fn create_task(input: Json<TaskInput>, state: &State<AppState>) -> Json<Task> {
    let mut tasks = state.tasks.lock().unwrap();
    let mut next_id = state.next_id.lock().unwrap();

    let task = Task {
        id: *next_id,
        name: input.name.clone(),
        description: input.description.clone(),
    };

    *next_id += 1;
    tasks.push(task.clone());

    Json(task)
}

#[delete("/api/tasks/<id>")]
fn delete_task(id: u32, state: &State<AppState>) {
    let mut tasks = state.tasks.lock().unwrap();
    tasks.retain(|task| task.id != id);
}

#[launch]
fn rocket() -> _ {
    rocket::build()
        .manage(AppState {
            tasks: Mutex::new(Vec::new()),
            next_id: Mutex::new(1),
        })
        .mount("/", routes![get_tasks, create_task, delete_task])
        .mount("/", FileServer::from(relative!("static")))
}
