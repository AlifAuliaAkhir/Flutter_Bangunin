const db = require('../db');

// Get all projects
exports.getAllProjects = async (req, res) => {
  try {
    const result = await db.query('SELECT * FROM projects');
    const projects = await Promise.all(result.rows.map(async (project) => {
      const materials = await db.query('SELECT * FROM materials WHERE project_id = $1', [project.id]);
      return { ...project, materials: materials.rows };
    }));
    res.json(projects);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// Add new project
exports.addProject = async (req, res) => {
  const { name } = req.body;
  try {
    await db.query('INSERT INTO projects (name, status) VALUES ($1, $2)', [name, 'berjalan']);
    res.status(201).send();
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// Delete project
exports.deleteProject = async (req, res) => {
  const { id } = req.params;
  try {
    await db.query('DELETE FROM materials WHERE project_id = $1', [id]);
    await db.query('DELETE FROM projects WHERE id = $1', [id]);
    res.send();
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// Add material to a project
exports.addMaterial = async (req, res) => {
  const { id } = req.params;
  const { nama, harga, jumlah } = req.body;
  try {
    await db.query(
      'INSERT INTO materials (project_id, nama, harga, jumlah) VALUES ($1, $2, $3, $4)',
      [id, nama, harga, jumlah]
    );
    res.status(201).send();
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// Finish project and calculate total
exports.finishProject = async (req, res) => {
  const { id } = req.params;
  try {
    await db.query('UPDATE projects SET status = $1 WHERE id = $2', ['selesai', id]);

    const totalResult = await db.query(
      'SELECT SUM(harga * jumlah) AS total FROM materials WHERE project_id = $1',
      [id]
    );

    const total = totalResult.rows[0].total || 0;
    res.json({ total });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
