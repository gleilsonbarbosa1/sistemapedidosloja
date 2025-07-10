/*
  # Update Products List

  1. Changes
    - Add "Leite líquido" to toppings
    - Add "Colher" to packages
    - Rename "Bobina filme" to "Papel filme"
*/

-- First, delete the old "Bobina filme" entry
DELETE FROM products 
WHERE name = 'Bobina filme' 
AND category_id = 'packages';

-- Insert or update products
INSERT INTO products (name, category_id) VALUES
  -- New topping
  ('Leite líquido', 'toppings'),
  
  -- Updated packages
  ('Papel filme', 'packages'),
  ('Colher', 'packages')
ON CONFLICT (id) DO UPDATE 
SET name = EXCLUDED.name,
    category_id = EXCLUDED.category_id;