/*
  # Update Toppings List

  1. Changes
    - Add missing toppings
    - Ensure consistent naming
    - Add popular combinations
*/

-- Add new toppings and ensure consistent naming
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
  
  -- Chocolates
  ('Chocolate Granulado', 'toppings'),
  ('Chocolate em Calda', 'toppings'),
  ('Kit Kat', 'toppings'),
  ('M&Ms', 'toppings'),
  ('Bis', 'toppings'),
  ('Sonho de Valsa', 'toppings'),
  ('Ferrero Rocher', 'toppings'),
  
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
  
  -- Caldas e Cremes
  ('Calda de Morango', 'toppings'),
  ('Calda de Chocolate', 'toppings'),
  ('Calda de Caramelo', 'toppings'),
  ('Doce de Leite', 'toppings'),
  ('Creme de Avelã', 'toppings'),
  ('Creme de Pistache', 'toppings'),
  
  -- Especiais
  ('Brigadeiro', 'toppings'),
  ('Beijinho', 'toppings'),
  ('Marshmallow', 'toppings'),
  ('Jujuba', 'toppings'),
  ('Gomas', 'toppings'),
  ('Chocoball', 'toppings')
ON CONFLICT (id) DO UPDATE 
SET name = EXCLUDED.name,
    category_id = EXCLUDED.category_id;