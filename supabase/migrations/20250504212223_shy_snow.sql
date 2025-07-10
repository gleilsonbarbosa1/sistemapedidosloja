/*
  # Restaurant Order Management System Schema

  1. New Tables
    - stores - Store locations
    - categories - Product categories
    - products - Available products
    - orders - Customer orders
    - order_items - Order line items
    - cash_closings - Daily cash register closings

  2. Security
    - Row Level Security enabled on all tables
    - Policies for authenticated users
*/

-- Criar tabela de lojas
CREATE TABLE IF NOT EXISTS stores (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Criar tabela de categorias
CREATE TABLE IF NOT EXISTS categories (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Criar tabela de produtos
CREATE TABLE IF NOT EXISTS products (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  category_id TEXT NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ
);

-- Criar tabela de pedidos
CREATE TABLE IF NOT EXISTS orders (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  store_id UUID NOT NULL REFERENCES stores(id),
  status TEXT NOT NULL DEFAULT 'draft' CHECK (status IN ('draft', 'pending', 'completed')),
  created_by UUID NOT NULL REFERENCES auth.users(id),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ,
  notes TEXT
);

-- Criar tabela de itens do pedido
CREATE TABLE IF NOT EXISTS order_items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id UUID NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
  product_id UUID NOT NULL REFERENCES products(id),
  quantity INTEGER NOT NULL CHECK (quantity >= 0),
  status TEXT NOT NULL DEFAULT 'full' CHECK (status IN ('full', 'half', 'empty')),
  has_stock BOOLEAN DEFAULT false,
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Criar tabela de fechamento de caixa
CREATE TABLE IF NOT EXISTS cash_closings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  store_id UUID NOT NULL REFERENCES stores(id),
  total_amount DECIMAL(10,2) NOT NULL,
  date DATE NOT NULL,
  created_by UUID NOT NULL REFERENCES auth.users(id),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  notes TEXT
);

-- Inserir categorias iniciais
INSERT INTO categories (id, name) VALUES
  ('toppings', 'Toppings'),
  ('fruits', 'Frutas'),
  ('packages', 'Embalagens e Insumos'),
  ('drinks', 'Bebidas'),
  ('toppings_sauces', 'Coberturas'),
  ('creams', 'Cremes'),
  ('acai', 'Açaí');

-- Inserir produtos iniciais
INSERT INTO products (name, category_id) VALUES
  -- Toppings
  ('Chocoball Power Branco', 'toppings'),
  ('Fine Beijinho', 'toppings'),
  ('Fine Amora', 'toppings'),
  ('Fine Bananinha', 'toppings'),
  ('Fine Tubo', 'toppings'),
  ('Fine Dentadura', 'toppings'),
  ('Doce de leite', 'toppings'),
  ('Chocowaffer', 'toppings'),
  ('Beijinho', 'toppings'),
  ('Paçoquita', 'toppings'),
  ('Ovomaltine', 'toppings'),
  ('Castanha Granulada', 'toppings'),
  ('Granola tradicional', 'toppings'),
  ('Amendoim', 'toppings'),
  ('Sucrilos', 'toppings'),
  ('Marshmallow', 'toppings'),
  ('Jujuba', 'toppings'),
  ('Brigadeiro', 'toppings'),
  ('Amendoim Colorido', 'toppings'),
  ('Ganache meio amargo', 'toppings'),
  ('Nutela', 'toppings'),
  ('Creme Cookies branco', 'toppings'),
  ('Recheio de Ninho', 'toppings'),
  ('Recheio de leitinho', 'toppings'),
  ('Creme de Leite', 'toppings'),
  ('Leite Condensado', 'toppings'),
  ('Leite Líquido', 'toppings'),
  ('Pasta de amendoin', 'toppings'),
  ('Pedacinho do Céu', 'toppings'),
  ('Chocolate', 'toppings'),
  ('Ninho', 'toppings'),
  ('Chiclete', 'toppings'),
  ('Napolitano', 'toppings'),
  ('Delícia de abacaxi', 'toppings'),
  ('Creme com passas', 'toppings'),
  ('Flocos', 'toppings'),
  ('Paçoca', 'toppings'),
  ('Barra de Cupuaçu', 'toppings'),
  ('Carmelo', 'toppings'),
  ('Ferreiro Rochê', 'toppings'),
  ('Casquinha', 'toppings'),

  -- Frutas
  ('Morango em caldas', 'fruits'),
  ('Morango Congelado', 'fruits'),
  ('Morango', 'fruits'),
  ('Kiwi', 'fruits'),
  ('Uva', 'fruits'),
  ('Cereja', 'fruits'),
  ('Manga', 'fruits'),
  ('Abacaxi ao Vinho', 'fruits'),
  ('Maracujá', 'fruits'),
  ('Cupuaçu', 'fruits'),

  -- Embalagens e Insumos
  ('Marmita 300g', 'packages'),
  ('Marmita 500g', 'packages'),
  ('Marmita 1kg', 'packages'),
  ('Tampas 300g', 'packages'),
  ('Tampas 500g', 'packages'),
  ('Tampas 1kg', 'packages'),
  ('Copos de 100ml', 'packages'),
  ('Copos de 300ml', 'packages'),
  ('Copos de 500ml', 'packages'),
  ('Copos de 770ml', 'packages'),
  ('Tampas de 100ml', 'packages'),
  ('Tampas de 5000ml', 'packages'),
  ('Guardanapo', 'packages'),
  ('Saco de lixo 200L', 'packages'),
  ('Sacolas Delivery N3', 'packages'),
  ('Sacolas brancas M', 'packages'),

  -- Bebidas
  ('AGUA COM GÁS', 'drinks'),
  ('AGUA SEM GÁS', 'drinks'),
  ('COCA-COLA', 'drinks'),
  ('COCA-COLA LATA', 'drinks'),

  -- Coberturas
  ('Cobertura de Chocolate', 'toppings_sauces'),
  ('Cobertura de Morango', 'toppings_sauces'),
  ('Cobertura de Uva', 'toppings_sauces'),
  ('Cobertura de Baunilha', 'toppings_sauces'),
  ('Cobertura de Carmelo', 'toppings_sauces'),
  ('Cobertura de Fine beijinho', 'toppings_sauces'),
  ('Cobertura de Fini dentadura', 'toppings_sauces'),
  ('Cobertura de Fini bananinha', 'toppings_sauces'),

  -- Cremes
  ('Creme de Ninho', 'creams'),
  ('Creme de Nutela', 'creams'),
  ('Creme de Ovomaltine', 'creams'),
  ('Creme de Cupuaçu', 'creams'),
  ('Creme de Morango', 'creams'),
  ('Creme de Paçoca', 'creams'),
  ('Creme de Barra de Cupuaçu', 'creams'),
  ('Creme de Maracujá', 'creams'),
  ('Creme de cookies cream', 'creams'),

  -- Açaí
  ('Açai Tradicional', 'acai'),
  ('Açai com Morango', 'acai'),
  ('Açai Fit', 'acai'),
  ('Açai com Banana', 'acai');

-- Inserir lojas iniciais
INSERT INTO stores (name) VALUES
  ('Loja 1'),
  ('Loja 2');

-- Habilitar RLS
ALTER TABLE stores ENABLE ROW LEVEL SECURITY;
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE cash_closings ENABLE ROW LEVEL SECURITY;

-- Políticas de segurança
CREATE POLICY "Todos podem ver lojas"
  ON stores FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Todos podem ver categorias"
  ON categories FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Todos podem ver produtos"
  ON products FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Usuários podem gerenciar seus próprios pedidos"
  ON orders FOR ALL
  TO authenticated
  USING (created_by = auth.uid());

CREATE POLICY "Usuários podem gerenciar seus próprios itens de pedido"
  ON order_items FOR ALL
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM orders
      WHERE orders.id = order_items.order_id
      AND orders.created_by = auth.uid()
    )
  );

CREATE POLICY "Usuários podem ver todos os fechamentos de caixa"
  ON cash_closings FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Usuários podem criar fechamentos de caixa"
  ON cash_closings FOR INSERT
  TO authenticated
  WITH CHECK (true);