-- PostgreSQL
-- Initialize the database.
-- Drop any existing data and create empty tables.

DROP TABLE IF EXISTS users;


CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  username TEXT UNIQUE NOT NULL,
  password TEXT NOT NULL,
  email TEXT
);


INSERT INTO users (username, password, email)
VALUES (
  'admin',
  'pbkdf2:sha256:260000$9EC3IpQ3g0KFeqcQ$77baab1421c7ffd936d3ef32dbb42eb8cd5b49af2d12605fc94b2b77732f5e79',
  'admin@admin.adm'
);
