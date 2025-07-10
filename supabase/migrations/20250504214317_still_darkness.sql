/*
  # Update packaging items

  1. Changes
    - Add new items:
      - Tampa de Copo de 300ml
      - Copo de 200ml
    - Rename items:
      - "Tampas 300g" to "Tampas marmita de 300g"
      - "Tampas 500g" to "Tampas marmita de 500g"
*/

-- First, delete the old items we want to rename
DELETE FROM products 
WHERE name IN ('Tampas 300g', 'Tampas 500g')
AND category_id = 'packages';

-- Insert new and renamed items
INSERT INTO products (name, category_id) VALUES
  ('Tampa de Copo de 300ml', 'packages'),
  ('Copo de 200ml', 'packages'),
  ('Tampas marmita de 300g', 'packages'),
  ('Tampas marmita de 500g', 'packages')
ON CONFLICT (id) DO UPDATE 
SET name = EXCLUDED.name,
    category_id = EXCLUDED.category_id;