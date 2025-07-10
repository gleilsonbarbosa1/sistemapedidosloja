/*
  # Disable Row Level Security

  1. Changes
    - Temporarily disable RLS on all tables
    - Drop existing policies
  
  2. Security Note
    - This is a temporary change
    - Should be re-enabled after testing/development
*/

-- Disable RLS on all tables
ALTER TABLE stores DISABLE ROW LEVEL SECURITY;
ALTER TABLE categories DISABLE ROW LEVEL SECURITY;
ALTER TABLE products DISABLE ROW LEVEL SECURITY;
ALTER TABLE orders DISABLE ROW LEVEL SECURITY;
ALTER TABLE order_items DISABLE ROW LEVEL SECURITY;
ALTER TABLE cash_closings DISABLE ROW LEVEL SECURITY;

-- Drop existing policies
DROP POLICY IF EXISTS "Todos podem ver lojas" ON stores;
DROP POLICY IF EXISTS "Todos podem ver categorias" ON categories;
DROP POLICY IF EXISTS "Todos podem ver produtos" ON products;
DROP POLICY IF EXISTS "Usuários podem gerenciar seus próprios pedidos" ON orders;
DROP POLICY IF EXISTS "Usuários podem gerenciar seus próprios itens de pedido" ON order_items;
DROP POLICY IF EXISTS "Usuários podem ver todos os fechamentos de caixa" ON cash_closings;
DROP POLICY IF EXISTS "Usuários podem criar fechamentos de caixa" ON cash_closings;
DROP POLICY IF EXISTS "Authenticated users can view products" ON products;