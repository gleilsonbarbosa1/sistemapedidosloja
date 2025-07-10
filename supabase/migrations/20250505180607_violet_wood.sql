/*
  # Create Products Schema

  1. New Tables
    - categories - Product categories with ordering
    - products - All available products
    
  2. Initial Data
    - Insert all categories
    - Insert unique products for each category
    
  3. Security
    - Enable RLS
    - Add policies for authenticated users
*/

-- Create categories table
CREATE TABLE IF NOT EXISTS categories (
  id text PRIMARY KEY,
  name text NOT NULL,
  order_index integer NOT NULL,
  created_at timestamptz DEFAULT now()
);

-- Create products table
CREATE TABLE IF NOT EXISTS products (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  category_id text REFERENCES categories(id) ON DELETE CASCADE,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz
);

-- Insert categories in proper order
INSERT INTO categories (id, name, order_index) VALUES
  ('toppings', 'Toppings', 1),
  ('fruits', 'Frutas', 2),
  ('packages', 'Embalagens e Insumos', 3),
  ('cleaning', 'Limpeza', 4),
  ('drinks', 'Bebidas', 5),
  ('toppings_sauces', 'Coberturas', 6),
  ('creams', 'Cremes', 7),
  ('ice_cream', 'Sorvetes', 8),
  ('acai', 'Açaí', 9)
ON CONFLICT (id) DO UPDATE 
SET name = EXCLUDED.name,
    order_index = EXCLUDED.order_index;

-- Insert all products with correct categorization
INSERT INTO products (name, category_id) VALUES
  -- Toppings
  ('Nutella', 'toppings'),
  ('Ganache meio amargo', 'toppings'),
  ('Ganache ao leite', 'toppings'),
  ('Abacaxi ao vinho', 'toppings'),
  ('Castanha', 'toppings'),
  ('Amendoim', 'toppings'),
  ('Castanha caramelizada', 'toppings'),
  ('Fini amora', 'toppings'),
  ('Fini beijinho', 'toppings'),
  ('Jujuba', 'toppings'),
  ('Fini tubets', 'toppings'),
  ('Fini gelatines', 'toppings'),
  ('Marshmallow', 'toppings'),
  ('Fini dentadura', 'toppings'),
  ('Canudo', 'toppings'),
  ('Fini bananinha', 'toppings'),
  ('Brownie', 'toppings'),
  ('Ovomaltine', 'toppings'),
  ('Leite em pó', 'toppings'),
  ('Pasta de amendoim', 'toppings'),
  ('Morango em calda', 'toppings'),
  ('Ferrero Rocher', 'toppings'),
  ('Chocowafer', 'toppings'),
  ('Brigadeiro', 'toppings'),
  ('Beijinho', 'toppings'),
  ('Creme de cookies', 'toppings'),
  ('Whey protein', 'toppings'),
  ('Raspa de chocolate', 'toppings'),
  ('Granola', 'toppings'),
  ('Leite condensado', 'toppings'),
  ('M&Ms', 'toppings'),
  ('Paçoca', 'toppings'),
  ('Sucrilhos', 'toppings'),
  ('Flocos de tapioca', 'toppings'),
  ('Farinha láctea', 'toppings'),
  ('Casquinha', 'toppings'),
  ('Barra de cupuaçu', 'toppings'),
  ('ChocoMine', 'toppings'),
  ('Gotas de chocolate', 'toppings'),
  ('Gotas de chocolate branco', 'toppings'),
  ('Amendoim colorido', 'toppings'),
  ('Recheio de pistache', 'toppings'),

  -- Frutas
  ('Morango', 'fruits'),
  ('Morango congelado', 'fruits'),
  ('Kiwi', 'fruits'),
  ('Uva', 'fruits'),
  ('Manga', 'fruits'),
  ('Maracujá', 'fruits'),
  ('Pitaya', 'fruits'),
  ('Banana', 'fruits'),

  -- Embalagens e Insumos
  ('Marmita 300g', 'packages'),
  ('Marmita 500g', 'packages'),
  ('Marmita 1kg', 'packages'),
  ('Tampa marmita 300g', 'packages'),
  ('Tampa marmita 500g', 'packages'),
  ('Tampa marmita 1kg', 'packages'),
  ('Pote 100ml', 'packages'),
  ('Copo 300ml', 'packages'),
  ('Copo 500ml', 'packages'),
  ('Copo 770ml', 'packages'),
  ('Tampa pote 100ml', 'packages'),
  ('Tampa copo 300ml', 'packages'),
  ('Tampa copo 500ml', 'packages'),
  ('Guardanapo', 'packages'),
  ('Saco de lixo 100L', 'packages'),
  ('Sacola delivery', 'packages'),
  ('Sacola branca', 'packages'),
  ('Bobina filme', 'packages'),
  ('Bobina cartão', 'packages'),
  ('Bobina impressora', 'packages'),

  -- Limpeza
  ('Álcool', 'cleaning'),
  ('Sabão', 'cleaning'),
  ('Desinfetante', 'cleaning'),
  ('Esponja', 'cleaning'),
  ('Detergente', 'cleaning'),
  ('Vinagre', 'cleaning'),
  ('Água sanitária', 'cleaning'),
  ('Perfect', 'cleaning'),
  ('Papel toalha', 'cleaning'),
  ('Papel higiênico', 'cleaning'),

  -- Bebidas
  ('Água com gás', 'drinks'),
  ('Água sem gás', 'drinks'),
  ('Coca-Cola', 'drinks'),
  ('Coca-Cola lata', 'drinks'),

  -- Coberturas
  ('Cobertura chocolate', 'toppings_sauces'),
  ('Cobertura morango', 'toppings_sauces'),
  ('Cobertura uva', 'toppings_sauces'),
  ('Cobertura baunilha', 'toppings_sauces'),
  ('Cobertura caramelo', 'toppings_sauces'),
  ('Cobertura beijinho', 'toppings_sauces'),
  ('Cobertura dentadura', 'toppings_sauces'),
  ('Cobertura limão', 'toppings_sauces'),
  ('Cobertura azul', 'toppings_sauces'),
  ('Cobertura leite', 'toppings_sauces'),
  ('Cobertura açaí', 'toppings_sauces'),
  ('Doce de leite', 'toppings_sauces'),

  -- Cremes
  ('Creme ninho', 'creams'),
  ('Creme nutella', 'creams'),
  ('Creme ovomaltine', 'creams'),
  ('Creme cupuaçu', 'creams'),
  ('Creme morango', 'creams'),
  ('Creme paçoca', 'creams'),
  ('Creme maracujá', 'creams'),
  ('Creme cookies', 'creams'),

  -- Sorvetes
  ('Sorvete pedacinho do céu', 'ice_cream'),
  ('Sorvete morango', 'ice_cream'),
  ('Sorvete chocolate', 'ice_cream'),
  ('Sorvete ninho', 'ice_cream'),
  ('Sorvete chiclete', 'ice_cream'),
  ('Sorvete napolitano', 'ice_cream'),
  ('Sorvete abacaxi', 'ice_cream'),
  ('Sorvete ovomaltine', 'ice_cream'),
  ('Sorvete creme passas', 'ice_cream'),
  ('Sorvete flocos', 'ice_cream'),
  ('Sorvete bombom', 'ice_cream'),
  ('Sorvete doce de leite', 'ice_cream'),
  ('Sorvete floresta negra', 'ice_cream'),
  ('Sorvete pavê', 'ice_cream'),

  -- Açaí
  ('Açaí tradicional', 'acai'),
  ('Açaí com morango', 'acai'),
  ('Açaí fit', 'acai'),
  ('Açaí com banana', 'acai');

-- Enable Row Level Security
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;

-- Create policies
CREATE POLICY "Enable read access for authenticated users"
  ON categories FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Enable read access for authenticated users"
  ON products FOR SELECT
  TO authenticated
  USING (true);

-- Create updated_at trigger
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_products_updated_at
  BEFORE UPDATE ON products
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();