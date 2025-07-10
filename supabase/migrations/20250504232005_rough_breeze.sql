/*
  # Simplify RLS Policies

  1. Changes
    - Disable RLS temporarily
    - Drop all existing policies
    - Create simplified policies without recursion
    - Re-enable RLS
*/

-- First disable RLS
ALTER TABLE stores DISABLE ROW LEVEL SECURITY;
ALTER TABLE categories DISABLE ROW LEVEL SECURITY;
ALTER TABLE products DISABLE ROW LEVEL SECURITY;
ALTER TABLE orders DISABLE ROW LEVEL SECURITY;
ALTER TABLE order_items DISABLE ROW LEVEL SECURITY;
ALTER TABLE cash_closings DISABLE ROW LEVEL SECURITY;
ALTER TABLE profiles DISABLE ROW LEVEL SECURITY;
ALTER TABLE menu_items DISABLE ROW LEVEL SECURITY;
ALTER TABLE daily_closings DISABLE ROW LEVEL SECURITY;

-- Drop all existing policies
DROP POLICY IF EXISTS "Authenticated users can view stores" ON stores;
DROP POLICY IF EXISTS "Authenticated users can view categories" ON categories;
DROP POLICY IF EXISTS "Managers and admins can modify categories" ON categories;
DROP POLICY IF EXISTS "Authenticated users can view products" ON products;
DROP POLICY IF EXISTS "Managers and admins can modify products" ON products;
DROP POLICY IF EXISTS "Authenticated users can view orders" ON orders;
DROP POLICY IF EXISTS "Authenticated users can create orders" ON orders;
DROP POLICY IF EXISTS "Authenticated users can update orders" ON orders;
DROP POLICY IF EXISTS "Authenticated users can view order items" ON order_items;
DROP POLICY IF EXISTS "Authenticated users can manage order items" ON order_items;
DROP POLICY IF EXISTS "Authenticated users can view cash closings" ON cash_closings;
DROP POLICY IF EXISTS "Managers and admins can manage cash closings" ON cash_closings;
DROP POLICY IF EXISTS "Authenticated users can view menu items" ON menu_items;
DROP POLICY IF EXISTS "Managers and admins can modify menu items" ON menu_items;
DROP POLICY IF EXISTS "Authenticated users can view daily closings" ON daily_closings;
DROP POLICY IF EXISTS "Managers and admins can manage daily closings" ON daily_closings;
DROP POLICY IF EXISTS "Users can view their own profile" ON profiles;
DROP POLICY IF EXISTS "Users can update their own profile" ON profiles;
DROP POLICY IF EXISTS "Managers and admins can view all profiles" ON profiles;
DROP POLICY IF EXISTS "Admins can manage all profiles" ON profiles;

-- Create simplified policies for profiles first
CREATE POLICY "Enable read access for all authenticated users"
  ON profiles FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Enable self update"
  ON profiles FOR UPDATE
  TO authenticated
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

-- Re-enable RLS with basic policies
ALTER TABLE stores ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Enable read access for authenticated users"
  ON stores FOR SELECT
  TO authenticated
  USING (true);

ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Enable read access for authenticated users"
  ON categories FOR SELECT
  TO authenticated
  USING (true);

ALTER TABLE products ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Enable read access for authenticated users"
  ON products FOR SELECT
  TO authenticated
  USING (true);

ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Enable read access for authenticated users"
  ON orders FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Enable insert for authenticated users"
  ON orders FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "Enable update for authenticated users"
  ON orders FOR UPDATE
  TO authenticated
  USING (true);

ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Enable all access for authenticated users"
  ON order_items FOR ALL
  TO authenticated
  USING (true);

ALTER TABLE cash_closings ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Enable read access for authenticated users"
  ON cash_closings FOR SELECT
  TO authenticated
  USING (true);

ALTER TABLE menu_items ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Enable read access for authenticated users"
  ON menu_items FOR SELECT
  TO authenticated
  USING (true);

ALTER TABLE daily_closings ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Enable read access for authenticated users"
  ON daily_closings FOR SELECT
  TO authenticated
  USING (true);