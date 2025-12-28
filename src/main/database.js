import path from 'path';
import { fileURLToPath } from 'url';
import Database from 'better-sqlite3';
import fs from 'fs';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const DB_PATH = path.join(__dirname, '..', 'database', 'main.db');
const SCHEMA_PATH = path.join(__dirname, '..', 'database', 'schema.sql');

export function initializeDatabase() {
  try {
    const dbDir = path.dirname(DB_PATH);
    if (!fs.existsSync(dbDir)) {
      fs.mkdirSync(dbDir, { recursive: true });
    }

    const db = new Database(DB_PATH);

    if (!fs.existsSync(DB_PATH) || fs.statSync(DB_PATH).size === 0) {
      const schema = fs.readFileSync(SCHEMA_PATH, 'utf-8');
      db.exec(schema);
      console.log('✅ Database initialized with schema');
    } else {
      console.log('✅ Database already exists');
    }

    const settingsCount = db.prepare('SELECT COUNT(*) as count FROM settings').get();
    if (settingsCount.count === 0) {
      db.prepare(
        'INSERT INTO settings (store_name, school_year) VALUES (?, ?)'
      ).run('Moja Szkoła', '2024/2025');
      console.log('✅ Default settings created');
    }

    db.close();
  } catch (error) {
    console.error('❌ Database initialization error:', error);
    throw error;
  }
}

export function executeQuery(query, params = []) {
  try {
    const db = new Database(DB_PATH);
    const stmt = db.prepare(query);
    const result = stmt.run(...params);
    db.close();
    return result;
  } catch (error) {
    console.error('Query execution error:', error);
    throw error;
  }
}

export function fetchData(query, params = []) {
  try {
    const db = new Database(DB_PATH);
    const stmt = db.prepare(query);
    const result = stmt.all(...params);
    db.close();
    return result;
  } catch (error) {
    console.error('Data fetch error:', error);
    throw error;
  }
}
