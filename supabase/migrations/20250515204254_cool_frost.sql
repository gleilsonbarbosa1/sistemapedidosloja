/*
  # Add New Package Items

  1. Changes
    - Add "Copo 400ml" to packages
    - Add "Tampa copo 400ml" to packages
*/

-- Insert new package items
INSERT INTO products (name, category_id) VALUES
  ('Copo 400ml', 'packages'),
  ('Tampa copo 400ml', 'packages')
ON CONFLICT (id) DO UPDATE 
SET name = EXCLUDED.name,
    category_id = EXCLUDED.category_id;