import { app, BrowserWindow, ipcMain, dialog } from 'electron';
import path from 'path';
import { fileURLToPath } from 'url';
import { initializeDatabase } from './database.js';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

let mainWindow;

app.on('ready', () => {
  initializeDatabase();
  createWindow();
});

function createWindow() {
  mainWindow = new BrowserWindow({
    width: 1200,
    height: 800,
    minWidth: 800,
    minHeight: 600,
    webPreferences: {
      preload: path.join(__dirname, 'preload.js'),
      contextIsolation: true,
      enableRemoteModule: false
    }
  });

  const indexPath = path.join(__dirname, '..', 'renderer', 'index.html');
  mainWindow.loadFile(indexPath);

  mainWindow.on('closed', () => {
    mainWindow = null;
  });
}

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    app.quit();
  }
});

// IPC HANDLERS

ipcMain.handle('get-students', async () => {
  try {
    const db = require('better-sqlite3')(path.join(__dirname, '..', 'database', 'main.db'));
    const stmt = db.prepare('SELECT * FROM students WHERE status = ?');
    const students = stmt.all('active');
    db.close();
    return students;
  } catch (error) {
    console.error('Error fetching students:', error);
    return { error: error.message };
  }
});

ipcMain.handle('add-student', async (event, studentData) => {
  try {
    const db = require('better-sqlite3')(path.join(__dirname, '..', 'database', 'main.db'));
    const stmt = db.prepare(
      'INSERT INTO students (first_name, last_name, group_id) VALUES (?, ?, ?)'
    );
    const result = stmt.run(
      studentData.first_name,
      studentData.last_name,
      studentData.group_id
    );
    db.close();
    return { success: true, id: result.lastInsertRowid };
  } catch (error) {
    console.error('Error adding student:', error);
    return { error: error.message };
  }
});
