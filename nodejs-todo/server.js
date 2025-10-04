const express = require('express');
const path = require('path');
const app = express();
const PORT = 3000;

// In-memory storage
let tasks = [];
let nextId = 1;

// Middleware
app.use(express.json());
app.use(express.static('public'));

// API Routes
app.get('/api/tasks', (req, res) => {
  res.json(tasks);
});

app.post('/api/tasks', (req, res) => {
  const { name, description } = req.body;
  const task = {
    id: nextId++,
    name,
    description
  };
  tasks.push(task);
  res.status(201).json(task);
});

app.delete('/api/tasks/:id', (req, res) => {
  const id = parseInt(req.params.id);
  tasks = tasks.filter(task => task.id !== id);
  res.status(204).send();
});

// Serve frontend
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});
