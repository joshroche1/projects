-- for PostgreSQL
--
-- Initialize the database.
-- Drop any existing data and create empty tables.

DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  username TEXT UNIQUE NOT NULL,
  password TEXT NOT NULL,
  email TEXT,
);

--
-- DEFAULT/EXAMPLE DATA
--

INSERT INTO users (username, password, email)
VALUES (
  'admin',
  '8c6976e5b541415bde98bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918',
  'admin@admin.adm'
);