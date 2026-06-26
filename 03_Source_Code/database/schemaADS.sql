DROP TABLE users;
drop table tickets;
drop table posts;
drop table notifications;

CREATE TABLE admins (
    id SERIAL PRIMARY KEY,
    nama VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash TEXT NOT NULL
);

CREATE TABLE mahasiswa (
    id SERIAL PRIMARY KEY,
    nama VARCHAR(100) NOT NULL,
    nim VARCHAR(30) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    no_telp VARCHAR(20),
    password_hash TEXT NOT NULL
);

-- Tabel tickets (laporan barang hilang/temuan oleh mahasiswa)
CREATE TABLE tickets (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES mahasiswa(id) ON DELETE CASCADE,
    tipe VARCHAR(10) NOT NULL,           -- 'hilang' | 'temuan'
    nama_barang VARCHAR(150) NOT NULL,
    deskripsi TEXT,
    ciri_barang TEXT,
    lokasi VARCHAR(200) NOT NULL,
    waktu_kejadian TIMESTAMP NOT NULL,
    no_telp varchar(13) not NULL,
    foto_url VARCHAR(500),               -- URL gambar (opsional)
    status VARCHAR(20) DEFAULT 'menunggu',
    -- status: 'menunggu' | 'diproses' | 'selesai' | 'ditolak' |
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Tabel posts (postingan barang temuan oleh Admin)
CREATE TABLE posts (
    id SERIAL PRIMARY KEY,
    admin_id INTEGER REFERENCES admins(id),
    judul VARCHAR(200) NOT NULL,
    deskripsi TEXT NOT NULL,
    lokasi_ditemukan VARCHAR(200),
    waktu_ditemukan TIMESTAMP,
    foto_url VARCHAR(500),
    status VARCHAR(20) DEFAULT 'tersedia', -- 'menunggu' | 'diproses' | 'selesai' | 'ditolak' |
    created_at TIMESTAMP DEFAULT NOW()
);

-- Tabel notifications
CREATE TABLE notifications (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES mahasiswa(id) ON DELETE CASCADE,
    judul VARCHAR(200) NOT NULL,
    pesan TEXT NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE audit_logs (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    user_role VARCHAR(20) NOT NULL,
    action VARCHAR(100) NOT NULL,
    resource VARCHAR(50),
    resource_id INTEGER,
    ip_address VARCHAR(45),
    detail TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

-- Indeks untuk performa query
CREATE INDEX idx_tickets_user_id ON tickets(user_id);
CREATE INDEX idx_tickets_status ON tickets(status);
CREATE INDEX idx_notifications_user_id ON notifications(user_id);
CREATE INDEX idx_notifications_is_read ON notifications(is_read);

ALTER TABLE mahasiswa
ALTER COLUMN email SET NOT NULL;

ALTER TABLE tickets
ALTER COLUMN no_telp DROP NOT NULL;

truncate table mahasiswa cascade;

ALTER TABLE tickets ADD COLUMN kategori VARCHAR(100);

UPDATE tickets
SET foto_url = 'https://example.com/foto.jpg'
WHERE id = 6;

DELETE FROM posts
WHERE id = 4;

delete from tickets 
where id =4;

SELECT id, ticket_id
FROM posts
WHERE ticket_id = 4;

DELETE FROM posts
WHERE ticket_id = 4;

ALTER TABLE posts ADD COLUMN tipe VARCHAR(10);

select * from mahasiswa;

ALTER TABLE posts
ADD COLUMN ticket_id INTEGER REFERENCES tickets(id);

SELECT id, nama_barang, status
FROM tickets;

UPDATE posts
SET status = 'ditolak'
WHERE ticket_id = '3';

ALTER TABLE notifications
ADD COLUMN ticket_id INTEGER REFERENCES tickets(id) ON DELETE CASCADE;

ALTER TABLE posts
ADD COLUMN kategori TEXT;

ALTER TABLE posts
ADD COLUMN tipe VARCHAR(20);

ALTER TABLE posts
ADD COLUMN status VARCHAR(100);

UPDATE tickets
SET status = 'menunggu'
WHERE id = 6;

ALTER TABLE mahasiswa
ALTER COLUMN nama TYPE TEXT;

ALTER TABLE mahasiswa
ALTER COLUMN no_telp TYPE TEXT;

select * from audit_logs;