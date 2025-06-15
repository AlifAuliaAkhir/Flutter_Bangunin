const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const { Pool } = require('pg');

const app = express();
app.use(cors());
app.use(bodyParser.json());

// 🔌 Koneksi ke PostgreSQL
const pool = new Pool({
  user: 'postgres',         
  host: 'localhost',        
  database: 'bangunin',
  password: 'alifaulia',
  port: 5432,               
});

// 🔍 GET semua project + material
app.get('/projects', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM projects ORDER BY id DESC');
    const projects = await Promise.all(result.rows.map(async (p) => {
      const materials = await pool.query(
        'SELECT * FROM materials WHERE project_id = $1',
        [p.id]
      );
      return { ...p, materials: materials.rows };
    }));
    res.json(projects);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// ➕ POST tambah project baru
app.post('/projects', async (req, res) => {
  const { name } = req.body;
  try {
    const result = await pool.query(
      'INSERT INTO projects (name, status) VALUES ($1, $2) RETURNING *',
      [name, 'berjalan']
    );
    res.status(201).json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// ➕ POST tambah bahan ke project
app.post('/projects/:id/materials', async (req, res) => {
  const { id } = req.params;
  const { nama, harga, jumlah } = req.body;
  try {
    await pool.query(
      'INSERT INTO materials (project_id, nama, harga, jumlah) VALUES ($1, $2, $3, $4)',
      [id, nama, harga, jumlah]
    );
    res.status(201).json({ message: 'Bahan ditambahkan' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// ✅ POST selesaikan project dan hitung total
app.post('/projects/:id/finish', async (req, res) => {
  const { id } = req.params;
  try {
    const result = await pool.query('SELECT * FROM materials WHERE project_id = $1', [id]);
    const total = result.rows.reduce((acc, m) => acc + m.harga * m.jumlah, 0);
    await pool.query('UPDATE projects SET status = $1 WHERE id = $2', ['selesai', id]);
    res.json({ total });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// ❌ DELETE project dan bahan-bahannya
app.delete('/projects/:id', async (req, res) => {
  const { id } = req.params;
  try {
    await pool.query('DELETE FROM materials WHERE project_id = $1', [id]);
    await pool.query('DELETE FROM projects WHERE id = $1', [id]);
    res.json({ message: 'Project dihapus' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

