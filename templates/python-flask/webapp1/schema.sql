-- Initialize the database.
-- Drop any existing data and create empty tables.

DROP TABLE IF EXISTS users;


CREATE TABLE users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  username TEXT UNIQUE NOT NULL,
  password TEXT NOT NULL,
  email TEXT
);


INSERT INTO users (username, password, email)
VALUES (
  'admin',
  'pbkdf2:sha256:260000$52GzsAuSP28X9AZ4$19d8484d9c15c83ccff1662f2cfc7ff3aa99410d0259d6a593e228016a7c1421',
  'admin@admin.adm'
);
