-- Seed data for the database probe: the demo query counts these rows.
CREATE TABLE demo_orders (
  id serial PRIMARY KEY,
  item text NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now()
);

INSERT INTO demo_orders (item) VALUES ('alpha'), ('beta'), ('gamma');
