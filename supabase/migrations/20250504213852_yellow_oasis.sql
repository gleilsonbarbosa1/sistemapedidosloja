/*
  # Add new toppings

  1. Changes
    - Add new toppings to the products table
    - Ensure first letter is capitalized
*/

-- Add new toppings
INSERT INTO products (name, category_id) VALUES
  ('Castanha Granulada', 'toppings'),
  ('Creme de Pistache', 'toppings'),
  ('Farinha de Amendoin', 'toppings'),
  ('Farinha de Castanha', 'toppings'),
  ('Xarope Po de Guarana', 'toppings'),
  ('Po de Guarana', 'toppings'),
  ('Gelo', 'toppings')
ON CONFLICT (id) DO UPDATE 
SET name = EXCLUDED.name,
    category_id = EXCLUDED.category_id;