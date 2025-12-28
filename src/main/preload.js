import { contextBridge, ipcRenderer } from 'electron';

contextBridge.exposeInMainWorld('api', {
  // Uczniowie
  getStudents: () => ipcRenderer.invoke('get-students'),
  addStudent: (data) => ipcRenderer.invoke('add-student', data),
  updateStudent: (id, data) => ipcRenderer.invoke('update-student', id, data),
  deleteStudent: (id) => ipcRenderer.invoke('delete-student', id),

  // Rodzice
  getParents: () => ipcRenderer.invoke('get-parents'),
  addParent: (data) => ipcRenderer.invoke('add-parent', data),

  // Grupy
  getGroups: () => ipcRenderer.invoke('get-groups'),
  addGroup: (data) => ipcRenderer.invoke('add-group', data),

  // Stawki
  getRates: (groupId) => ipcRenderer.invoke('get-rates', groupId),
  setRates: (groupId, rates) => ipcRenderer.invoke('set-rates', groupId, rates),

  // Obecności
  getAttendance: (studentId, month) => ipcRenderer.invoke('get-attendance', studentId, month),
  markAttendance: (studentId, date, data) => ipcRenderer.invoke('mark-attendance', studentId, date, data),

  // Rozliczenia
  getMonthlyCharges: (studentId, month) => ipcRenderer.invoke('get-monthly-charges', studentId, month),
  calculateCharges: (month) => ipcRenderer.invoke('calculate-charges', month),

  // Wpłaty
  recordPayment: (data) => ipcRenderer.invoke('record-payment', data),
  getPayments: (studentId) => ipcRenderer.invoke('get-payments', studentId),

  // Dokumenty
  generateInvoice: (studentId, month) => ipcRenderer.invoke('generate-invoice', studentId, month),

  // Ustawienia
  getSettings: () => ipcRenderer.invoke('get-settings'),
  updateSettings: (data) => ipcRenderer.invoke('update-settings', data),

  // Licencja
  validateLicense: (key, storeName) => ipcRenderer.invoke('validate-license', key, storeName),
});
