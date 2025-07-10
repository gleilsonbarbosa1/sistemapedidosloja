/*
  # Create stores table

  1. New Tables
    - `stores`
      - `id` (uuid, primary key)
      - `name` (text, not null)
      - `created_at` (timestamptz, default: now())

  2. Security
    - Enable RLS on `stores` table
    - Add policy for authenticated users to read stores data
*/

CREATE TABLE IF NOT EXISTS stores (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  created_at timestamptz DEFAULT now()
);

-- Enable Row Level Security
ALTER TABLE stores ENABLE ROW LEVEL SECURITY;

-- Create policy to allow authenticated users to read stores
CREATE POLICY "Enable read access for authenticated users"
  ON stores
  FOR SELECT
  TO authenticated
  USING (true);

-- Insert initial store data
INSERT INTO stores (name) VALUES
  ('Loja 1'),
  ('Loja 2')
ON CONFLICT (id) DO NOTHING;