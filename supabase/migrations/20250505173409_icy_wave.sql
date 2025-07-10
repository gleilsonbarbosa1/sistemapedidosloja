/*
  # Create categories table

  1. New Tables
    - `categories`
      - `id` (text, primary key)
      - `name` (text, not null)
      - `order_index` (integer, not null)
      - `created_at` (timestamptz, default now())

  2. Security
    - Enable RLS on `categories` table
    - Add policy for authenticated users to read categories
*/

CREATE TABLE IF NOT EXISTS categories (
  id text PRIMARY KEY,
  name text NOT NULL,
  order_index integer NOT NULL,
  created_at timestamptz DEFAULT now()
);

-- Enable Row Level Security
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;

-- Create policy to allow authenticated users to read categories
CREATE POLICY "Enable read access for authenticated users"
  ON categories
  FOR SELECT
  TO authenticated
  USING (true);

-- Insert some initial categories
INSERT INTO categories (id, name, order_index) VALUES
  ('beverages', 'Beverages', 1),
  ('main_dishes', 'Main Dishes', 2),
  ('pizzas', 'Pizzas', 3),
  ('sandwiches', 'Sandwiches', 4)
ON CONFLICT (id) DO NOTHING;