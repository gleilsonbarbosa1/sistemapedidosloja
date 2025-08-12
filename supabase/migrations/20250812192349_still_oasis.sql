/*
  # Add Sample Categories and Products

  1. Sample Categories
    - Creates basic categories for the açaí store
    
  2. Sample Products  
    - Creates sample products for each category
    
  3. Data Structure
    - Categories with proper order_index
    - Products linked to categories
*/

-- Insert sample categories if they don't exist
INSERT INTO categories (id, name, order_index) VALUES
  ('acai', 'Açaí', 1),
  ('bebidas', 'Bebidas', 2),
  ('complementos', 'Complementos', 3),
  ('sobremesas', 'Sobremesas', 4),
  ('outros', 'Outros', 5)
ON CONFLICT (id) DO NOTHING;

-- Insert sample products if they don't exist
INSERT INTO products (name, category_id) VALUES
  -- Açaí products
  ('Açaí 300ml', 'acai'),
  ('Açaí 500ml', 'acai'),
  ('Açaí 700ml', 'acai'),
  ('Açaí 1L', 'acai'),
  
  -- Bebidas
  ('Água Mineral', 'bebidas'),
  ('Refrigerante Coca-Cola', 'bebidas'),
  ('Suco Natural', 'bebidas'),
  ('Água de Coco', 'bebidas'),
  
  -- Complementos
  ('Granola', 'complementos'),
  ('Leite Condensado', 'complementos'),
  ('Mel', 'complementos'),
  ('Banana', 'complementos'),
  ('Morango', 'complementos'),
  ('Castanha', 'complementos'),
  ('Paçoca', 'complementos'),
  
  -- Sobremesas
  ('Sorvete Chocolate', 'sobremesas'),
  ('Sorvete Baunilha', 'sobremesas'),
  ('Picolé', 'sobremesas'),
  
  -- Outros
  ('Guardanapo', 'outros'),
  ('Copo Descartável', 'outros'),
  ('Colher Descartável', 'outros')
ON CONFLICT DO NOTHING;