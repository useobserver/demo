-- Seed data for the database probe: the demo query counts these rows.
CREATE TABLE demo_orders (
  id INT AUTO_INCREMENT PRIMARY KEY,
  item VARCHAR(64) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO demo_orders (item) VALUES ('alpha'), ('beta'), ('gamma');
