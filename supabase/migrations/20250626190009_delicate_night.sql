/*
  # Add Chocoball and Cereja to Toppings

  1. Changes
    - Add "Chocoball" to toppings category
    - Add "Cereja" to toppings category
*/

-- Insert new toppings
INSERT INTO products (name, category_id) VALUES
  ('Chocoball', 'toppings'),
  ('Cereja', 'toppings')
ON CONFLICT (id) DO UPDATE 
SET name = EXCLUDED.name,
    category_id = EXCLUDED.category_id;