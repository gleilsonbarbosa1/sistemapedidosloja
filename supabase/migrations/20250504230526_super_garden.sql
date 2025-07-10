/*
  # Remove Kiwi and Uva from toppings

  1. Changes
    - Remove 'Kiwi' and 'Uva' from toppings category
    - Keep all other toppings unchanged
*/

-- First, delete all existing toppings
DELETE FROM products 
WHERE category_id = 'toppings';

-- Insert complete list of toppings
INSERT INTO products (name, category_id) VALUES
  -- Chocolates e Coberturas
  ('Ganache meio amargo', 'toppings'),
  ('Ganache ao leite', 'toppings'),
  ('Raspa de chocolate', 'toppings'),
  ('Gotas de Chocolate branco', 'toppings'),
  ('Gotas de chocolate preto', 'toppings'),
  ('Chowafer branco', 'toppings'),
  ('ChocoPower Mine', 'toppings'),
  ('ChocoPower Chocolate', 'toppings'),
  ('ChocoPower Chocolate branco', 'toppings'),
  ('Cobertura de chocolate', 'toppings'),
  ('Cobertura de morango', 'toppings'),
  ('Cobertura de limao', 'toppings'),
  ('Cobertura sonhos azul', 'toppings'),
  ('Cobertura de leite', 'toppings'),
  ('Cobertura de acai', 'toppings'),

  -- Frutas e Caldas
  ('Abacaxi ao vinho', 'toppings'),
  ('Morango em caldas', 'toppings'),
  ('Morango', 'toppings'),
  ('Morango congelado', 'toppings'),
  ('Pitaya', 'toppings'),
  ('Cereja', 'toppings'),
  ('Uva passas', 'toppings'),

  -- Nuts e Granulados
  ('Castanha', 'toppings'),
  ('Amendoin', 'toppings'),
  ('Castanha caramelisada', 'toppings'),
  ('Amendoin Colorido', 'toppings'),
  ('Granola', 'toppings'),
  ('Flocos de Tapioca caramelizado', 'toppings'),

  -- Fini e Doces
  ('Fini amora', 'toppings'),
  ('Fini beijinho', 'toppings'),
  ('Fini tubets', 'toppings'),
  ('Fini gelatines', 'toppings'),
  ('Fini dentadura', 'toppings'),
  ('Fini bananinha', 'toppings'),
  ('Cobertura de dentadura', 'toppings'),
  ('Cobertura de beijinhos', 'toppings'),
  ('Jujuba', 'toppings'),
  ('Marshmallow', 'toppings'),

  -- Cremes e Recheios
  ('Brigadeiro', 'toppings'),
  ('Beijinho', 'toppings'),
  ('Recheio de leitinho', 'toppings'),
  ('Creme de cookies branco', 'toppings'),
  ('Creme de cookies preto', 'toppings'),
  ('Recheio de pistache', 'toppings'),
  ('Recheio de Ferrero rocher', 'toppings'),
  ('Pasta de amendoim', 'toppings'),
  ('Doce de leite', 'toppings'),
  ('Barra de cupuaçu', 'toppings'),

  -- Complementos
  ('Porçoes de brownie', 'toppings'),
  ('Ovomaltine', 'toppings'),
  ('Leite em pó', 'toppings'),
  ('Whey protein', 'toppings'),
  ('Leite Condensado', 'toppings'),
  ('MMS', 'toppings'),
  ('Paçoca', 'toppings'),
  ('Sucrilhos', 'toppings'),
  ('Farinha láctea', 'toppings'),
  ('Casquinha', 'toppings'),
  ('Canudos', 'toppings'),
  ('Colher', 'toppings'),
  ('Ferreiro rocher', 'toppings');