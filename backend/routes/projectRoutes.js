const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const { Pool } = require('pg');

const app = express();
app.use(cors());
app.use(bodyParser.json());

// GET all projects
app.get('/projects', async (req, res) => {
  const result = await pool.query('SELECT * FROM projects ORDER BY id DESC');
  res.json(result.rows);
});

// POST new project
app.post('/projects', async (req, res) => {
  const { name } = req.body;
  const result = await pool.query(
    'INSERT INTO projects (name, status) VALUES ($1, $2) RETURNING *',
    [name, 'berjalan']
  );
  res.status(201).json(result.rows[0]);
});

// POST material
app.post('/projects/:id/materials', async (req, res) => {
  const { id } = req.params;
  const { nama, harga, jumlah } = req.body;
  await pool.query(
    'INSERT INTO materials (project_id, nama, harga, jumlah) VALUES ($1, $2, $3, $4)',
    [id, nama, harga, jumlah]
  );
  res.status(201).json({ message: 'Bahan ditambahkan' });
});

// POST finish project
app.post('/projects/:id/finish', async (req, res) => {
  const { id } = req.params;
  const result = await pool.query('SELECT * FROM materials WHERE project_id = $1', [id]);
  const total = result.rows.reduce((acc, m) => acc + m.harga * m.jumlah, 0);
  await pool.query('UPDATE projects SET status = $1 WHERE id = $2', ['selesai', id]);
  res.json({ total });
});

// DELETE project
app.delete('/projects/:id', async (req, res) => {
  const { id } = req.params;
  await pool.query('DELETE FROM materials WHERE project_id = $1', [id]);
  await pool.query('DELETE FROM projects WHERE id = $1', [id]);
  res.json({ message: 'Project dihapus' });
});

app.listen(3000, () => console.log('🚀 Server berjalan di http://localhost:3000'));
