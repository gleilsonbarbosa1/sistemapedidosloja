/*
  # Restaurant Management System Schema

  1. New Tables
    - `profiles` - User profiles with roles (staff, manager, admin)
    - `categories` - Menu categories
    - `menu_items` - Food and beverage items
    - `orders` - Customer orders
    - `order_items` - Line items for each order
    - `daily_closings` - Daily cash register closing records

  2. Security
    - Row Level Security enabled on all tables
    - Policies for role-based access control
*/

-- Create profiles table for user information and roles
CREATE TABLE IF NOT EXISTS profiles (
  id UUID PRIMARY KEY REFERENCES auth.users ON DELETE CASCADE,
  email TEXT NOT NULL UNIQUE,
  role TEXT NOT NULL DEFAULT 'staff' CHECK (role IN ('staff', 'manager', 'admin')),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ
);

-- Create categories table
CREATE TABLE IF NOT EXISTS categories (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create menu_items table
CREATE TABLE IF NOT EXISTS menu_items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  description TEXT,
  price DECIMAL(10, 2) NOT NULL CHECK (price >= 0),
  category TEXT NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
  image_url TEXT,
  available BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ
);

-- Create orders table
CREATE TABLE IF NOT EXISTS orders (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  customer_name TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'completed', 'cancelled')),
  total_amount DECIMAL(10, 2) NOT NULL DEFAULT 0,
  table_number INTEGER CHECK (table_number > 0),
  order_type TEXT NOT NULL CHECK (order_type IN ('dine_in', 'takeout', 'delivery')),
  payment_method TEXT CHECK (payment_method IN ('cash', 'card', 'digital')),
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  created_by UUID REFERENCES profiles(id),
  updated_at TIMESTAMPTZ,
  updated_by UUID REFERENCES profiles(id)
);

-- Create order_items table
CREATE TABLE IF NOT EXISTS order_items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id UUID NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
  menu_item_id UUID NOT NULL REFERENCES menu_items(id),
  quantity INTEGER NOT NULL CHECK (quantity > 0),
  unit_price DECIMAL(10, 2) NOT NULL CHECK (unit_price >= 0),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create daily_closings table
CREATE TABLE IF NOT EXISTS daily_closings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  date DATE NOT NULL UNIQUE,
  cash_amount DECIMAL(10, 2) NOT NULL DEFAULT 0,
  card_amount DECIMAL(10, 2) NOT NULL DEFAULT 0,
  digital_amount DECIMAL(10, 2) NOT NULL DEFAULT 0,
  total_amount DECIMAL(10, 2) NOT NULL DEFAULT 0,
  order_count INTEGER NOT NULL DEFAULT 0,
  notes TEXT,
  closed_by UUID NOT NULL REFERENCES profiles(id),
  closed_at TIMESTAMPTZ NOT NULL
);

-- Seed initial categories
INSERT INTO categories (id, name, description)
VALUES
  ('beverages', 'Beverages', 'Drinks and refreshments'),
  ('appetizers', 'Appetizers', 'Small dishes to start your meal'),
  ('main_dishes', 'Main Dishes', 'Hearty entrees and main courses'),
  ('pizzas', 'Pizzas', 'Our signature wood-fired pizzas'),
  ('desserts', 'Desserts', 'Sweet treats to end your meal'),
  ('sides', 'Sides', 'Additional sides and small plates'),
  ('sandwiches', 'Sandwiches', 'Freshly prepared sandwiches');

-- Add sample menu items
INSERT INTO menu_items (name, description, price, category, available)
VALUES
  ('House Coffee', 'Our signature blend, freshly brewed', 2.95, 'beverages', TRUE),
  ('Iced Tea', 'Freshly brewed and chilled', 2.50, 'beverages', TRUE),
  ('Margherita Pizza', 'Classic with tomato sauce, mozzarella, and basil', 12.95, 'pizzas', TRUE),
  ('Pepperoni Pizza', 'Classic pepperoni with mozzarella cheese', 14.95, 'pizzas', TRUE),
  ('Caesar Salad', 'Romaine lettuce, croutons, parmesan, and Caesar dressing', 9.95, 'appetizers', TRUE),
  ('French Fries', 'Crispy golden fries with sea salt', 4.95, 'sides', TRUE),
  ('Cheeseburger', 'Angus beef with cheddar, lettuce, tomato, and special sauce', 12.95, 'main_dishes', TRUE),
  ('Chocolate Cake', 'Rich chocolate layer cake with ganache', 6.95, 'desserts', TRUE),
  ('Club Sandwich', 'Triple-decker with turkey, bacon, lettuce, and tomato', 11.95, 'sandwiches', TRUE),
  ('Veggie Wrap', 'Seasonal vegetables with hummus in a wheat wrap', 10.95, 'sandwiches', TRUE);

-- Enable Row Level Security
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE menu_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE daily_closings ENABLE ROW LEVEL SECURITY;

-- Create authentication trigger for new users
CREATE OR REPLACE FUNCTION public.handle_new_user() 
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, email, role)
  VALUES (new.id, new.email, 'staff');
  RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- RLS Policies for profiles
CREATE POLICY "Users can view their own profile"
  ON profiles FOR SELECT
  USING (auth.uid() = id);

CREATE POLICY "Managers and admins can view all profiles"
  ON profiles FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE id = auth.uid() AND role IN ('manager', 'admin')
    )
  );

CREATE POLICY "Admins can update profiles"
  ON profiles FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE id = auth.uid() AND role = 'admin'
    )
  );

-- RLS Policies for categories
CREATE POLICY "Anyone can view categories"
  ON categories FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Managers and admins can modify categories"
  ON categories FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE id = auth.uid() AND role IN ('manager', 'admin')
    )
  );

-- RLS Policies for menu_items
CREATE POLICY "Anyone can view menu items"
  ON menu_items FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Managers and admins can modify menu items"
  ON menu_items FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE id = auth.uid() AND role IN ('manager', 'admin')
    )
  );

-- RLS Policies for orders
CREATE POLICY "Staff can view orders"
  ON orders FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Staff can create orders"
  ON orders FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "Staff can update orders"
  ON orders FOR UPDATE
  TO authenticated
  USING (true);

-- RLS Policies for order_items
CREATE POLICY "Staff can view order items"
  ON order_items FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Staff can manage order items"
  ON order_items FOR ALL
  TO authenticated
  USING (true);

-- RLS Policies for daily_closings
CREATE POLICY "Staff can view daily closings"
  ON daily_closings FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Managers and admins can manage daily closings"
  ON daily_closings FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE id = auth.uid() AND role IN ('manager', 'admin')
    )
  );