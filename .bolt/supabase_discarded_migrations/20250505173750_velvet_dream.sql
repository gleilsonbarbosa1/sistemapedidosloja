/*
  # Açaí Shop System Schema

  1. New Tables
    - `categories` - Product categories specific to açaí shop
    - `products` - Açaí products and toppings
    - `orders` - Customer orders
    - `order_items` - Items in each order
    - `cash_closings` - Daily cash register closings

  2. Security
    - Enable RLS on all tables
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

-- Create orders table
CREATE TABLE IF NOT EXISTS orders (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  customer_name text NOT NULL,
  status text NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'completed', 'cancelled')),
  total_amount decimal(10,2) NOT NULL DEFAULT 0,
  table_number integer CHECK (table_number > 0),
  order_type text NOT NULL CHECK (order_type IN ('dine_in', 'takeout', 'delivery')),
  notes text,
  created_at timestamptz DEFAULT now(),
  created_by uuid REFERENCES auth.users(id),
  updated_at timestamptz,
  updated_by uuid REFERENCES auth.users(id)
);

-- Create order_items table
CREATE TABLE IF NOT EXISTS order_items (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id uuid NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
  product_id uuid NOT NULL REFERENCES products(id),
  quantity integer NOT NULL CHECK (quantity > 0),
  status text NOT NULL DEFAULT 'full' CHECK (status IN ('full', 'half', 'empty')),
  has_stock boolean DEFAULT true,
  notes text,
  created_at timestamptz DEFAULT now()
);

-- Create cash_closings table
CREATE TABLE IF NOT EXISTS cash_closings (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  total_amount decimal(10,2) NOT NULL,
  cash_left_amount decimal(10,2),
  delivery_amount decimal(10,2),
  food_amount decimal(10,2),
  daily_purchase_amount decimal(10,2),
  attendant text NOT NULL,
  date date NOT NULL,
  notes text,
  created_at timestamptz DEFAULT now(),
  created_by uuid REFERENCES auth.users(id)
);

-- Insert açaí shop categories
INSERT INTO categories (id, name, order_index) VALUES
  ('acai', 'Açaí', 1),
  ('toppings', 'Toppings', 2),
  ('fruits', 'Frutas', 3),
  ('creams', 'Cremes', 4),
  ('sauces', 'Caldas', 5),
  ('drinks', 'Bebidas', 6),
  ('packages', 'Embalagens', 7)
ON CONFLICT (id) DO UPDATE 
SET name = EXCLUDED.name,
    order_index = EXCLUDED.order_index;

-- Enable Row Level Security
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE cash_closings ENABLE ROW LEVEL SECURITY;

-- Create policies
CREATE POLICY "Enable read access for authenticated users"
  ON categories FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Enable read access for authenticated users"
  ON products FOR SELECT
  TO authenticated
  USING (true);

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

CREATE POLICY "Enable read access for authenticated users"
  ON order_items FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Enable insert for authenticated users"
  ON order_items FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "Enable update for authenticated users"
  ON order_items FOR UPDATE
  TO authenticated
  USING (true);

CREATE POLICY "Enable read access for authenticated users"
  ON cash_closings FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Enable insert for authenticated users"
  ON cash_closings FOR INSERT
  TO authenticated
  WITH CHECK (true);