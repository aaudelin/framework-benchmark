// Fetch and display all tasks
async function loadTasks() {
    const response = await fetch('/api/tasks');
    const tasks = await response.json();

    const taskList = document.getElementById('taskList');

    if (tasks.length === 0) {
        taskList.innerHTML = '<div class="empty-state">No tasks yet. Add one above!</div>';
        return;
    }

    taskList.innerHTML = tasks.map(task => `
        <div class="task-item">
            <div class="task-header">
                <h3 class="task-name">${escapeHtml(task.name)}</h3>
                <button class="delete-btn" onclick="deleteTask(${task.id})">Delete</button>
            </div>
            <p class="task-description">${escapeHtml(task.description)}</p>
        </div>
    `).join('');
}

// Add a new task
async function addTask() {
    const name = document.getElementById('taskName').value.trim();
    const description = document.getElementById('taskDescription').value.trim();

    if (!name) {
        alert('Please enter a task name');
        return;
    }

    await fetch('/api/tasks', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({ name, description })
    });

    document.getElementById('taskName').value = '';
    document.getElementById('taskDescription').value = '';

    loadTasks();
}

// Delete a task
async function deleteTask(id) {
    await fetch(`/api/tasks/${id}`, {
        method: 'DELETE'
    });

    loadTasks();
}

// Escape HTML to prevent XSS
function escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}

// Load tasks on page load
loadTasks();
