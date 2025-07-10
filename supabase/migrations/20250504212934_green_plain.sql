/*
  # Update Products and Categories

  1. Changes
    - Add new categories: Cleaning and Ice Cream
    - Update existing products
    - Add new products
    - Remove outdated products

  2. Security
    - Maintains existing RLS policies
*/

-- Update categories order
UPDATE categories
SET order_index = CASE id
  WHEN 'toppings' THEN 1
  WHEN 'fruits' THEN 2
  WHEN 'packages' THEN 3
  WHEN 'cleaning' THEN 4
  WHEN 'drinks' THEN 5
  WHEN 'toppings_sauces' THEN 6
  WHEN 'creams' THEN 7
  WHEN 'ice_cream' THEN 8
  WHEN 'acai' THEN 9
  ELSE order_index
END;

-- Add new categories if they don't exist
INSERT INTO categories (id, name, order_index)
VALUES
  ('cleaning', 'Limpeza', 4),
  ('ice_cream', 'Sorvetes', 8)
ON CONFLICT (id) DO UPDATE
SET name = EXCLUDED.name, order_index = EXCLUDED.order_index;

-- Delete all existing products to avoid duplicates
DELETE FROM products;

-- Insert all products with updated names and categories
INSERT INTO products (name, category_id) VALUES
  -- Toppings
  ('Nutela', 'toppings'),
  ('Ganache meio amargo', 'toppings'),
  ('Ganache ao leite', 'toppings'),
  ('Abacaxi ao vinho', 'toppings'),
  ('Castanha', 'toppings'),
  ('Amendoin', 'toppings'),
  ('Castanha caramelisada', 'toppings'),
  ('Fini amora', 'toppings'),
  ('Fini beijinho', 'toppings'),
  ('Jujuba', 'toppings'),
  ('Fini tubets', 'toppings'),
  ('Fini gelatines', 'toppings'),
  ('Marshmallow', 'toppings'),
  ('Fini dentadura', 'toppings'),
  ('Canudos', 'toppings'),
  ('Fini bananinha', 'toppings'),
  ('Porçoes de brownie', 'toppings'),
  ('Ovomaltine', 'toppings'),
  ('Leite em pó', 'toppings'),
  ('Pasta de amendoim', 'toppings'),
  ('Morango em caldas', 'toppings'),
  ('Ferreiro rocher', 'toppings'),
  ('Chowafer branco', 'toppings'),
  ('Brigadeiro', 'toppings'),
  ('Beijinho', 'toppings'),
  ('Recheio de leitinho', 'toppings'),
  ('Creme de cookies branco', 'toppings'),
  ('Creme de cookies preto', 'toppings'),
  ('Whey protein', 'toppings'),
  ('Cereja', 'toppings'),
  ('Raspa de chocolate', 'toppings'),
  ('Morango', 'toppings'),
  ('Uva', 'toppings'),
  ('Kiwi', 'toppings'),
  ('Pitaya', 'toppings'),
  ('Uva passas', 'toppings'),
  ('Granola', 'toppings'),
  ('Leite Condensado', 'toppings'),
  ('MMS', 'toppings'),
  ('Paçoca', 'toppings'),
  ('Sucrilhos', 'toppings'),
  ('Flocos de Tapioca caramelizado', 'toppings'),
  ('Farinha láctea', 'toppings'),
  ('Amendoin Colorido', 'toppings'),
  ('Casquinha', 'toppings'),
  ('Colher', 'toppings'),
  ('Recheio de pistache', 'toppings'),
  ('Barra de cupuaçu', 'toppings'),
  ('Morango congelado', 'toppings'),
  ('ChocoPower Mine', 'toppings'),
  ('ChocoPower Chocolate', 'toppings'),
  ('ChocoPower Chocolate branco', 'toppings'),
  ('Gotas de Chocolate branco', 'toppings'),
  ('Gotas de chocolate preto', 'toppings'),

  -- Frutas
  ('Morango', 'fruits'),
  ('Kiwi', 'fruits'),
  ('Uva', 'fruits'),
  ('Cereja', 'fruits'),
  ('Manga', 'fruits'),
  ('Maracujá', 'fruits'),
  ('Cupuaçu', 'fruits'),
  ('Pitaya', 'fruits'),
  ('Banana', 'fruits'),

  -- Embalagens e Insumos
  ('Marmita 300g', 'packages'),
  ('Marmita 500g', 'packages'),
  ('Marmita 1kg', 'packages'),
  ('Tampas 300g', 'packages'),
  ('Tampas 500g', 'packages'),
  ('Tampas 1kg', 'packages'),
  ('Pote de 100ml', 'packages'),
  ('Copos de 300ml', 'packages'),
  ('Copos de 500ml', 'packages'),
  ('Copos de 770ml', 'packages'),
  ('Tampa para pote de 100ml', 'packages'),
  ('Tampas de 5000ml', 'packages'),
  ('Guardanapo', 'packages'),
  ('Sacos de lixo 100L reforçado', 'packages'),
  ('Sacolas Delivery N3', 'packages'),
  ('Sacolas brancas M', 'packages'),
  ('Bobina plástico de filme', 'packages'),
  ('Bobina de cartão', 'packages'),
  ('Bobina de impressora', 'packages'),

  -- Limpeza
  ('Álcool', 'cleaning'),
  ('Sabão', 'cleaning'),
  ('Desinfetante', 'cleaning'),
  ('Esponja', 'cleaning'),
  ('Detergente', 'cleaning'),
  ('Vinagre', 'cleaning'),
  ('Qboa', 'cleaning'),
  ('Perfect', 'cleaning'),
  ('Papel Toalha', 'cleaning'),
  ('Papel Higiênico', 'cleaning'),

  -- Bebidas
  ('Agua com Gás', 'drinks'),
  ('Agua sem Gás', 'drinks'),
  ('Coquinha', 'drinks'),
  ('Coca Lata', 'drinks'),

  -- Coberturas
  ('Cobertura de dentadura', 'toppings_sauces'),
  ('Cobertura de beijinhos', 'toppings_sauces'),
  ('Cobertura de chocolate', 'toppings_sauces'),
  ('Cobertura de morango', 'toppings_sauces'),
  ('Cobertura de limao', 'toppings_sauces'),
  ('Cobertura sonhos azul', 'toppings_sauces'),
  ('Cobertura de leite', 'toppings_sauces'),
  ('Doce de leite', 'toppings_sauces'),
  ('Cobertura de acai', 'toppings_sauces'),
  ('Recheio de Ferrero rocher', 'toppings_sauces'),

  -- Cremes
  ('Creme Ninho', 'creams'),
  ('Creme Nutela', 'creams'),
  ('Creme Ovomaltine', 'creams'),
  ('Creme de Cupuaçu', 'creams'),
  ('Creme Morango', 'creams'),
  ('Creme Paçoca', 'creams'),
  ('Creme Maracujá', 'creams'),
  ('Creme Cookies', 'creams'),

  -- Sorvetes
  ('Sorvete Pedacinho do Céu', 'ice_cream'),
  ('Sorvete Morango', 'ice_cream'),
  ('Sorvete Chocolate', 'ice_cream'),
  ('Sorvete Ninho', 'ice_cream'),
  ('Sorvete Chiclete', 'ice_cream'),
  ('Sorvete Napolitano', 'ice_cream'),
  ('Sorvete Delicia de abacaxi', 'ice_cream'),
  ('Sorvete Ovomaltine', 'ice_cream'),
  ('Sorvete Creme com passas', 'ice_cream'),
  ('Sorvete Flocos', 'ice_cream'),
  ('Sorvete bombom', 'ice_cream'),
  ('Sorvete doce de leite', 'ice_cream'),
  ('Sorvete floresta negra', 'ice_cream'),
  ('Sorvete pavê', 'ice_cream'),

  -- Açaí
  ('Açaí Tradicional', 'acai'),
  ('Açaí com Morango', 'acai'),
  ('Açaí Fit', 'acai'),
  ('Açaí com Banana', 'acai');