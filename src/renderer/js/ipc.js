/**
 * IPC Communication
 * Wrappers dla bezpiecznej komunikacji z main procesem
 */

export const ipc = {
    // Uczniowie
    async getStudents() {
        return window.api.getStudents();
    },

    async addStudent(data) {
        return window.api.addStudent(data);
    },

    // Rodzice
    async getParents() {
        return window.api.getParents();
    },

    // Grupy
    async getGroups() {
        return window.api.getGroups();
    },
};
