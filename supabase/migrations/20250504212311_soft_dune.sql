/*
  # Fix Products and Categories Tables

  1. Changes
    - Add `order_index` column to `categories` table
    - Add default value and NOT NULL constraint to ensure proper ordering
    - Add check constraint to ensure positive values

  2. New Tables
    - `products` table with columns:
      - `id` (uuid, primary key)
      - `name` (text)
      - `category_id` (text, foreign key to categories)
      - `created_at` (timestamptz)
      - `updated_at` (timestamptz)

  3. Security
    - Enable RLS on products table
    - Add policy for authenticated users to view products
*/

-- Add order_index to categories
DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'categories' AND column_name = 'order_index'
  ) THEN
    ALTER TABLE categories 
    ADD COLUMN order_index integer NOT NULL DEFAULT 0;

    ALTER TABLE categories 
    ADD CONSTRAINT categories_order_index_check 
    CHECK (order_index >= 0);
  END IF;
END $$;

-- Create products table if it doesn't exist
CREATE TABLE IF NOT EXISTS products (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  category_id text NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz,
  CONSTRAINT products_name_not_empty CHECK (length(trim(name)) > 0)
);

-- Enable RLS
ALTER TABLE products ENABLE ROW LEVEL SECURITY;

-- Add RLS policies
CREATE POLICY "Authenticated users can view products"
  ON products
  FOR SELECT
  TO authenticated
  USING (true);