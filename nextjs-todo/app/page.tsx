'use client';

import { useState, useEffect } from 'react';
import './styles.css';

interface Task {
  id: number;
  name: string;
  description: string;
}

export default function Home() {
  const [tasks, setTasks] = useState<Task[]>([]);
  const [name, setName] = useState('');
  const [description, setDescription] = useState('');

  useEffect(() => {
    loadTasks();
  }, []);

  async function loadTasks() {
    const response = await fetch('/api/tasks');
    const data = await response.json();
    setTasks(data);
  }

  async function addTask() {
    if (!name.trim()) {
      alert('Please enter a task name');
      return;
    }

    await fetch('/api/tasks', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ name, description }),
    });

    setName('');
    setDescription('');
    loadTasks();
  }

  async function deleteTask(id: number) {
    await fetch(`/api/tasks/${id}`, {
      method: 'DELETE',
    });
    loadTasks();
  }

  return (
    <div className="container">
      <header>
        <h1>📝 Todo List</h1>
        <p className="framework-badge">Next.js</p>
      </header>

      <div className="add-task-form">
        <input
          type="text"
          placeholder="Task name"
          value={name}
          onChange={(e) => setName(e.target.value)}
        />
        <textarea
          placeholder="Task description"
          value={description}
          onChange={(e) => setDescription(e.target.value)}
        />
        <button onClick={addTask}>Add Task</button>
      </div>

      <div className="task-list">
        {tasks.length === 0 ? (
          <div className="empty-state">No tasks yet. Add one above!</div>
        ) : (
          tasks.map((task) => (
            <div key={task.id} className="task-item">
              <div className="task-header">
                <h3 className="task-name">{task.name}</h3>
                <button className="delete-btn" onClick={() => deleteTask(task.id)}>
                  Delete
                </button>
              </div>
              <p className="task-description">{task.description}</p>
            </div>
          ))
        )}
      </div>
    </div>
  );
}
