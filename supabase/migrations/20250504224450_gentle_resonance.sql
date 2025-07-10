/*
  # Update Toppings Items

  1. Changes
    - Add missing toppings items
    - Fix categorization
    - Ensure all items are properly ordered
*/

-- Add new toppings
INSERT INTO products (name, category_id) VALUES
  -- Additional Toppings
  ('Leite em Pó', 'toppings'),
  ('Granola Tradicional', 'toppings'),
  ('Granola Fit', 'toppings'),
  ('Amendoim Triturado', 'toppings'),
  ('Castanha do Pará', 'toppings'),
  ('Castanha de Caju', 'toppings'),
  ('Chocoball', 'toppings'),
  ('Confete', 'toppings'),
  ('Gotas de Chocolate', 'toppings'),
  ('Calda de Chocolate', 'toppings'),
  ('Calda de Morango', 'toppings'),
  ('Calda de Caramelo', 'toppings'),
  ('Leite Condensado', 'toppings'),
  ('Creme de Avelã', 'toppings'),
  ('Creme de Ovomaltine', 'toppings'),
  ('Paçoca Triturada', 'toppings'),
  ('Biscoito Oreo', 'toppings'),
  ('Cereal de Chocolate', 'toppings'),
  ('Mel', 'toppings'),
  ('Coco Ralado', 'toppings'),
  ('Banana em Rodelas', 'toppings'),
  ('Morango em Pedaços', 'toppings'),
  ('Kiwi em Fatias', 'toppings'),
  ('Uva sem Caroço', 'toppings'),
  ('Manga em Cubos', 'toppings')
ON CONFLICT (id) DO UPDATE 
SET name = EXCLUDED.name,
    category_id = EXCLUDED.category_id;