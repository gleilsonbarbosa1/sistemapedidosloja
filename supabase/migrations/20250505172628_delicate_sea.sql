/*
  # Drop Unused Tables

  1. Changes
    - Drop unused tables and their dependencies
    - Remove associated policies
    - Clean up database schema
*/

-- Drop policies first to avoid conflicts
DO $$ 
BEGIN
  -- Drop policies for cash_closings
  DROP POLICY IF EXISTS "Enable read access for authenticated users" ON cash_closings;
  DROP POLICY IF EXISTS "Enable insert for authenticated users" ON cash_closings;

  -- Drop policies for categories
  DROP POLICY IF EXISTS "Enable read access for authenticated users" ON categories;

  -- Drop policies for daily_closings
  DROP POLICY IF EXISTS "Enable read access for authenticated users" ON daily_closings;

  -- Drop policies for menu_items
  DROP POLICY IF EXISTS "Enable read access for authenticated users" ON menu_items;

  -- Drop policies for order_items
  DROP POLICY IF EXISTS "Enable read access for authenticated users" ON order_items;
  DROP POLICY IF EXISTS "Enable insert for authenticated users" ON order_items;
  DROP POLICY IF EXISTS "Enable update for authenticated users" ON order_items;

  -- Drop policies for orders
  DROP POLICY IF EXISTS "Enable read access for authenticated users" ON orders;
  DROP POLICY IF EXISTS "Enable insert for authenticated users" ON orders;
  DROP POLICY IF EXISTS "Enable update for authenticated users" ON orders;
END $$;

-- Drop tables in correct order to handle dependencies
DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS menu_items CASCADE;
DROP TABLE IF EXISTS daily_closings CASCADE;
DROP TABLE IF EXISTS cash_closings CASCADE;
DROP TABLE IF EXISTS categories CASCADE;