/*
  # Add New Toppings

  1. Changes
    - Add new toppings items
    - Ensure proper capitalization
*/

-- Add new toppings
INSERT INTO products (name, category_id) VALUES
  ('Castanha granulada', 'toppings'),
  ('Creme de pistache', 'toppings'),
  ('Farinha de amendoim', 'toppings'),
  ('Farinha de castanha', 'toppings'),
  ('Xarope de guarana', 'toppings'),
  ('Po de guarana', 'toppings'),
  ('Gelo', 'toppings')
ON CONFLICT (id) DO UPDATE 
SET name = EXCLUDED.name,
    category_id = EXCLUDED.category_id;