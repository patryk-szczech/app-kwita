-- ============================================
-- KWITARIUSZ SZKOŁY - Database Schema v1.0
-- SQLite
-- ============================================

CREATE TABLE IF NOT EXISTS settings (
    id INTEGER PRIMARY KEY,
    store_name TEXT NOT NULL,
    school_year TEXT NOT NULL,
    nip TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS groups (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE,
    type TEXT CHECK(type IN ('przedszkole', 'szkoła')) NOT NULL,
    status TEXT DEFAULT 'active' CHECK(status IN ('active', 'inactive')),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS students (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    group_id INTEGER NOT NULL,
    status TEXT DEFAULT 'active' CHECK(status IN ('active', 'inactive')),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (group_id) REFERENCES groups(id)
);

CREATE TABLE IF NOT EXISTS parents (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    email TEXT,
    phone TEXT,
    status TEXT DEFAULT 'active' CHECK(status IN ('active', 'inactive')),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS student_parents (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    student_id INTEGER NOT NULL,
    parent_id INTEGER NOT NULL,
    relationship TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(id),
    FOREIGN KEY (parent_id) REFERENCES parents(id),
    UNIQUE(student_id, parent_id)
);

CREATE TABLE IF NOT EXISTS rates (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    group_id INTEGER NOT NULL,
    breakfast DECIMAL(7,2) DEFAULT 0,
    second_breakfast DECIMAL(7,2) DEFAULT 0,
    lunch DECIMAL(7,2) DEFAULT 0,
    snack DECIMAL(7,2) DEFAULT 0,
    full_day DECIMAL(7,2) DEFAULT 0,
    valid_from DATE NOT NULL,
    valid_to DATE,
    status TEXT DEFAULT 'active' CHECK(status IN ('active', 'inactive')),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (group_id) REFERENCES groups(id)
);

CREATE TABLE IF NOT EXISTS holidays (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    date DATE UNIQUE NOT NULL,
    name TEXT NOT NULL,
    type TEXT CHECK(type IN ('holiday', 'weekend', 'custom')),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS attendance (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    student_id INTEGER NOT NULL,
    attendance_date DATE NOT NULL,
    present BOOLEAN DEFAULT 1,
    breakfast BOOLEAN DEFAULT 0,
    second_breakfast BOOLEAN DEFAULT 0,
    lunch BOOLEAN DEFAULT 1,
    snack BOOLEAN DEFAULT 0,
    notes TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(id),
    UNIQUE(student_id, attendance_date)
);

CREATE TABLE IF NOT EXISTS monthly_charges (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    student_id INTEGER NOT NULL,
    month DATE NOT NULL,
    days_present INTEGER DEFAULT 0,
    breakfast_charges DECIMAL(10,2) DEFAULT 0,
    second_breakfast_charges DECIMAL(10,2) DEFAULT 0,
    lunch_charges DECIMAL(10,2) DEFAULT 0,
    snack_charges DECIMAL(10,2) DEFAULT 0,
    total_amount DECIMAL(10,2) DEFAULT 0,
    status TEXT DEFAULT 'pending' CHECK(status IN ('pending', 'charged', 'paid')),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(id),
    UNIQUE(student_id, month)
);

CREATE TABLE IF NOT EXISTS payments (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    student_id INTEGER NOT NULL,
    parent_id INTEGER,
    amount DECIMAL(10,2) NOT NULL,
    payment_date DATE NOT NULL,
    payment_method TEXT CHECK(payment_method IN ('cash', 'transfer', 'card')),
    notes TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(id),
    FOREIGN KEY (parent_id) REFERENCES parents(id)
);

CREATE TABLE IF NOT EXISTS documents (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    student_id INTEGER NOT NULL,
    month DATE NOT NULL,
    document_number TEXT UNIQUE NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    issued_date DATE NOT NULL,
    pdf_path TEXT,
    status TEXT DEFAULT 'generated' CHECK(status IN ('generated', 'sent', 'archived')),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(id)
);

CREATE TABLE IF NOT EXISTS licenses (
    id INTEGER PRIMARY KEY,
    store_name TEXT NOT NULL UNIQUE,
    machine_id TEXT NOT NULL UNIQUE,
    license_key TEXT NOT NULL UNIQUE,
    activation_date DATETIME,
    status TEXT DEFAULT 'active' CHECK(status IN ('active', 'inactive', 'expired')),
    expiry_date DATE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_students_group ON students(group_id);
CREATE INDEX idx_students_status ON students(status);
CREATE INDEX idx_attendance_student ON attendance(student_id);
CREATE INDEX idx_attendance_date ON attendance(attendance_date);
CREATE INDEX idx_charges_student ON monthly_charges(student_id);
CREATE INDEX idx_payments_student ON payments(student_id);
CREATE INDEX idx_payments_date ON payments(payment_date);
CREATE INDEX idx_documents_student ON documents(student_id);
CREATE INDEX idx_rates_group ON rates(group_id);
CREATE INDEX idx_rates_valid ON rates(valid_from, valid_to);
