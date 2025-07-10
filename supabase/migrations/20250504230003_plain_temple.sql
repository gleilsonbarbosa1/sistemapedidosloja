/*
  # Remove Duplicate Toppings

  1. Changes
    - Remove duplicate toppings entries
    - Standardize toppings names
    - Keep only unique items
*/

-- First, delete all existing toppings
DELETE FROM products 
WHERE category_id = 'toppings';

-- Insert unique toppings with standardized names
INSERT INTO products (name, category_id) VALUES
  -- Essential Toppings
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
  ('Kit Kat', 'toppings'),
  ('M&Ms', 'toppings'),
  ('Bis', 'toppings'),
  ('Sonho de Valsa', 'toppings'),
  ('Ferrero Rocher', 'toppings'),
  ('Brigadeiro', 'toppings'),
  ('Beijinho', 'toppings'),
  ('Chocoball', 'toppings'),
  ('ChocoPower Branco', 'toppings'),
  ('ChocoPower Mine', 'toppings'),
  ('ChocoPower Chocolate', 'toppings'),
  
  -- Cookies e Cereais
  ('Oreo', 'toppings'),
  ('Negresco', 'toppings'),
  ('Sucrilhos', 'toppings'),
  ('Cookie', 'toppings'),
  ('Wafer', 'toppings'),
  
  -- Caldas e Cremes
  ('Calda de Morango', 'toppings'),
  ('Calda de Chocolate', 'toppings'),
  ('Calda de Caramelo', 'toppings'),
  ('Doce de Leite', 'toppings'),
  ('Creme de Avelã', 'toppings'),
  ('Creme de Pistache', 'toppings'),
  ('Creme de Cookies', 'toppings'),
  ('Pasta de Amendoim', 'toppings'),
  
  -- Fini e Doces
  ('Marshmallow', 'toppings'),
  ('Jujuba', 'toppings'),
  ('Fini Amora', 'toppings'),
  ('Fini Morango', 'toppings'),
  ('Fini Tubes', 'toppings'),
  ('Fini Dentadura', 'toppings'),
  ('Fini Banana', 'toppings'),
  
  -- Outros
  ('Farinha Láctea', 'toppings'),
  ('Coco Ralado', 'toppings'),
  ('Canudo', 'toppings'),
  ('Casquinha', 'toppings');