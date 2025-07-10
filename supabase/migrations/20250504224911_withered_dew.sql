/*
  # Update Toppings List

  1. Changes
    - Ensure all toppings are properly listed
    - Remove duplicates
    - Standardize naming
*/

-- First, remove any duplicate entries
DELETE FROM products a USING products b
WHERE a.ctid < b.ctid 
AND a.name = b.name 
AND a.category_id = b.category_id;

-- Update and insert all toppings
INSERT INTO products (name, category_id) VALUES
  -- Essential Toppings
  ('Morango Congelado', 'toppings'),
  ('Morango em Calda', 'toppings'),
  ('Leite em Pó', 'toppings'),
  ('Leite Condensado', 'toppings'),
  ('Nutella', 'toppings'),
  ('Ovomaltine', 'toppings'),
  ('Paçoca', 'toppings'),
  ('Granola', 'toppings'),
  ('Amendoim', 'toppings'),
  ('Castanha', 'toppings'),
  ('Castanha Granulada', 'toppings'),
  ('Castanha Caramelizada', 'toppings'),
  
  -- Chocolates e Doces
  ('Chocolate Granulado', 'toppings'),
  ('Calda de Chocolate', 'toppings'),
  ('Kit Kat', 'toppings'),
  ('M&Ms', 'toppings'),
  ('Bis', 'toppings'),
  ('Sonho de Valsa', 'toppings'),
  ('Ferrero Rocher', 'toppings'),
  ('Brigadeiro', 'toppings'),
  ('Beijinho', 'toppings'),
  ('Chocoball', 'toppings'),
  ('Gotas de Chocolate', 'toppings'),
  ('Gotas de Chocolate Branco', 'toppings'),
  
  -- Cookies e Cereais
  ('Oreo', 'toppings'),
  ('Negresco', 'toppings'),
  ('Sucrilhos', 'toppings'),
  ('Cookie', 'toppings'),
  ('Wafer', 'toppings'),
  
  -- Frutas
  ('Banana', 'toppings'),
  ('Kiwi', 'toppings'),
  ('Uva', 'toppings'),
  ('Manga', 'toppings'),
  ('Abacaxi', 'toppings'),
  ('Maracujá', 'toppings'),
  ('Morango', 'toppings'),
  ('Cereja', 'toppings'),
  ('Uva Passa', 'toppings'),
  
  -- Caldas e Cremes
  ('Calda de Morango', 'toppings'),
  ('Calda de Caramelo', 'toppings'),
  ('Doce de Leite', 'toppings'),
  ('Creme de Avelã', 'toppings'),
  ('Creme de Pistache', 'toppings'),
  ('Creme de Cookies', 'toppings'),
  ('Pasta de Amendoim', 'toppings'),
  
  -- Especiais
  ('Marshmallow', 'toppings'),
  ('Jujuba', 'toppings'),
  ('Gomas', 'toppings'),
  ('Fini Amora', 'toppings'),
  ('Fini Morango', 'toppings'),
  ('Fini Tubes', 'toppings'),
  ('Fini Dentadura', 'toppings'),
  ('Fini Banana', 'toppings'),
  ('Farinha Láctea', 'toppings'),
  ('Paçoca Triturada', 'toppings'),
  ('Coco Ralado', 'toppings')
ON CONFLICT (id) DO UPDATE 
SET name = EXCLUDED.name,
    category_id = EXCLUDED.category_id;