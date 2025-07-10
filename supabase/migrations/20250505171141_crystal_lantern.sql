/*
  # Fix RLS Policies

  1. Changes
    - Disable RLS temporarily
    - Drop existing policies
    - Create simplified policies
    - Re-enable RLS with proper checks
*/

-- First disable RLS on all tables
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
DO $$ 
BEGIN
  -- Drop policies for profiles
  IF EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'profiles' AND policyname = 'Enable read access for authenticated users') THEN
    DROP POLICY "Enable read access for authenticated users" ON profiles;
  END IF;
  IF EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'profiles' AND policyname = 'Enable update for users based on id') THEN
    DROP POLICY "Enable update for users based on id" ON profiles;
  END IF;

  -- Drop policies for stores
  IF EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'stores' AND policyname = 'Enable read access for authenticated users') THEN
    DROP POLICY "Enable read access for authenticated users" ON stores;
  END IF;

  -- Drop policies for categories
  IF EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'categories' AND policyname = 'Enable read access for authenticated users') THEN
    DROP POLICY "Enable read access for authenticated users" ON categories;
  END IF;

  -- Drop policies for products
  IF EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'products' AND policyname = 'Enable read access for authenticated users') THEN
    DROP POLICY "Enable read access for authenticated users" ON products;
  END IF;

  -- Drop policies for orders
  IF EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'orders' AND policyname = 'Enable read access for authenticated users') THEN
    DROP POLICY "Enable read access for authenticated users" ON orders;
  END IF;
  IF EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'orders' AND policyname = 'Enable insert for authenticated users') THEN
    DROP POLICY "Enable insert for authenticated users" ON orders;
  END IF;
  IF EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'orders' AND policyname = 'Enable update for authenticated users') THEN
    DROP POLICY "Enable update for authenticated users" ON orders;
  END IF;

  -- Drop policies for order_items
  IF EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'order_items' AND policyname = 'Enable read access for authenticated users') THEN
    DROP POLICY "Enable read access for authenticated users" ON order_items;
  END IF;
  IF EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'order_items' AND policyname = 'Enable insert for authenticated users') THEN
    DROP POLICY "Enable insert for authenticated users" ON order_items;
  END IF;
  IF EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'order_items' AND policyname = 'Enable update for authenticated users') THEN
    DROP POLICY "Enable update for authenticated users" ON order_items;
  END IF;

  -- Drop policies for cash_closings
  IF EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'cash_closings' AND policyname = 'Enable read access for authenticated users') THEN
    DROP POLICY "Enable read access for authenticated users" ON cash_closings;
  END IF;
  IF EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'cash_closings' AND policyname = 'Enable insert for authenticated users') THEN
    DROP POLICY "Enable insert for authenticated users" ON cash_closings;
  END IF;

  -- Drop policies for menu_items
  IF EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'menu_items' AND policyname = 'Enable read access for authenticated users') THEN
    DROP POLICY "Enable read access for authenticated users" ON menu_items;
  END IF;

  -- Drop policies for daily_closings
  IF EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'daily_closings' AND policyname = 'Enable read access for authenticated users') THEN
    DROP POLICY "Enable read access for authenticated users" ON daily_closings;
  END IF;
END $$;

-- Re-enable RLS with simplified policies
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
DO $$ 
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'profiles' AND policyname = 'Enable read access for authenticated users') THEN
    CREATE POLICY "Enable read access for authenticated users"
      ON profiles FOR SELECT
      TO authenticated
      USING (true);
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'profiles' AND policyname = 'Enable update for users based on id') THEN
    CREATE POLICY "Enable update for users based on id"
      ON profiles FOR UPDATE
      TO authenticated
      USING (auth.uid() = id)
      WITH CHECK (auth.uid() = id);
  END IF;
END $$;

ALTER TABLE stores ENABLE ROW LEVEL SECURITY;
DO $$ 
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'stores' AND policyname = 'Enable read access for authenticated users') THEN
    CREATE POLICY "Enable read access for authenticated users"
      ON stores FOR SELECT
      TO authenticated
      USING (true);
  END IF;
END $$;

ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
DO $$ 
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'categories' AND policyname = 'Enable read access for authenticated users') THEN
    CREATE POLICY "Enable read access for authenticated users"
      ON categories FOR SELECT
      TO authenticated
      USING (true);
  END IF;
END $$;

ALTER TABLE products ENABLE ROW LEVEL SECURITY;
DO $$ 
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'products' AND policyname = 'Enable read access for authenticated users') THEN
    CREATE POLICY "Enable read access for authenticated users"
      ON products FOR SELECT
      TO authenticated
      USING (true);
  END IF;
END $$;

ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
DO $$ 
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'orders' AND policyname = 'Enable read access for authenticated users') THEN
    CREATE POLICY "Enable read access for authenticated users"
      ON orders FOR SELECT
      TO authenticated
      USING (true);
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'orders' AND policyname = 'Enable insert for authenticated users') THEN
    CREATE POLICY "Enable insert for authenticated users"
      ON orders FOR INSERT
      TO authenticated
      WITH CHECK (true);
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'orders' AND policyname = 'Enable update for authenticated users') THEN
    CREATE POLICY "Enable update for authenticated users"
      ON orders FOR UPDATE
      TO authenticated
      USING (true);
  END IF;
END $$;

ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;
DO $$ 
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'order_items' AND policyname = 'Enable read access for authenticated users') THEN
    CREATE POLICY "Enable read access for authenticated users"
      ON order_items FOR SELECT
      TO authenticated
      USING (true);
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'order_items' AND policyname = 'Enable insert for authenticated users') THEN
    CREATE POLICY "Enable insert for authenticated users"
      ON order_items FOR INSERT
      TO authenticated
      WITH CHECK (true);
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'order_items' AND policyname = 'Enable update for authenticated users') THEN
    CREATE POLICY "Enable update for authenticated users"
      ON order_items FOR UPDATE
      TO authenticated
      USING (true);
  END IF;
END $$;

ALTER TABLE cash_closings ENABLE ROW LEVEL SECURITY;
DO $$ 
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'cash_closings' AND policyname = 'Enable read access for authenticated users') THEN
    CREATE POLICY "Enable read access for authenticated users"
      ON cash_closings FOR SELECT
      TO authenticated
      USING (true);
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'cash_closings' AND policyname = 'Enable insert for authenticated users') THEN
    CREATE POLICY "Enable insert for authenticated users"
      ON cash_closings FOR INSERT
      TO authenticated
      WITH CHECK (true);
  END IF;
END $$;

ALTER TABLE menu_items ENABLE ROW LEVEL SECURITY;
DO $$ 
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'menu_items' AND policyname = 'Enable read access for authenticated users') THEN
    CREATE POLICY "Enable read access for authenticated users"
      ON menu_items FOR SELECT
      TO authenticated
      USING (true);
  END IF;
END $$;

ALTER TABLE daily_closings ENABLE ROW LEVEL SECURITY;
DO $$ 
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'daily_closings' AND policyname = 'Enable read access for authenticated users') THEN
    CREATE POLICY "Enable read access for authenticated users"
      ON daily_closings FOR SELECT
      TO authenticated
      USING (true);
  END IF;
END $$;