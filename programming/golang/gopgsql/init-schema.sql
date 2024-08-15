DROP TABLE IF EXISTS items;
CREATE TABLE items (
  id            SERIAL PRIMARY KEY,
  name          VARCHAR(255) NOT NULL,
  category      VARCHAR(255) NOT NULL,
  price         DECIMAL(255) NOT NULL,
  description   VARCHAR(255)
);

INSERT INTO items (name, category, price) VALUES ('Dell G5', 'Electronics', 850.00);
INSERT INTO items (name, category, price) VALUES ('Lenovo ThinkPad', 'Electronics', 1275.00);
INSERT INTO items (name, category, price) VALUES ('Orange', 'Groceries', 0.50);
INSERT INTO items (name, category, price) VALUES ('Apple', 'Groceries', 0.45);
INSERT INTO items (name, category, price) VALUES ('Oxford English Dictionary', 'Books', 850.00);
INSERT INTO items (name, category, price) VALUES ('Notepad, A4', 'Stationary', 850.00);