/*
  # Drop All Tables

  1. Changes
    - Drop all existing tables
    - Remove all policies
    - Clean up database schema
*/

-- Drop all policies first
DO $$ 
DECLARE
  _tbl text;
  _pol text;
BEGIN
  FOR _tbl, _pol IN 
    SELECT tablename, policyname 
    FROM pg_policies 
    WHERE schemaname = 'public'
  LOOP
    EXECUTE format('DROP POLICY IF EXISTS %I ON %I', _pol, _tbl);
  END LOOP;
END $$;

-- Drop all tables in correct order to handle dependencies
DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS menu_items CASCADE;
DROP TABLE IF EXISTS daily_closings CASCADE;
DROP TABLE IF EXISTS cash_closings CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS categories CASCADE;
DROP TABLE IF EXISTS profiles CASCADE;
DROP TABLE IF EXISTS stores CASCADE;

-- Drop any remaining functions
DROP FUNCTION IF EXISTS handle_new_user() CASCADE;