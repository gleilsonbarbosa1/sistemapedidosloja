/*
  # Create categories table if not exists

  1. New Tables
    - categories
      - id (text, primary key)
      - name (text, not null)
      - order_index (integer, not null)
      - created_at (timestamptz, default now())

  2. Security
    - Enable RLS
*/

-- Create categories table if it doesn't exist
CREATE TABLE IF NOT EXISTS categories (
  id text PRIMARY KEY,
  name text NOT NULL,
  order_index integer NOT NULL,
  created_at timestamptz DEFAULT now()
);

-- Enable RLS
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;

-- Drop existing policy if it exists
DROP POLICY IF EXISTS "Enable read access for authenticated users" ON categories;

-- Create policy
CREATE POLICY "Enable read access for authenticated users"
  ON categories
  FOR SELECT
  TO authenticated
  USING (true);