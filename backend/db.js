const pool = new Pool({
  user: 'postgres',         
  host: 'localhost',
  database: 'bangunin',     
  password: 'alifaulia', 
  port: 5432,
});

module.exports = pool;