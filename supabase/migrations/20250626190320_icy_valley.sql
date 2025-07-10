/*
  # Update Cream and Toppings Categories

  1. Changes
    - Move "Creme de pistache" from toppings to creams
    - Add "Creme de cookies branco" to toppings
    - Add "Creme de cookies preto" to toppings
    - Add "Recheio de leitinho" to toppings
*/

-- Move "Creme de pistache" from toppings to creams
UPDATE products 
SET category_id = 'creams'
WHERE name = 'Creme de pistache' 
AND category_id = 'toppings';

-- Add new cream items to toppings
INSERT INTO products (name, category_id) VALUES
  ('Creme de cookies branco', 'toppings'),
  ('Creme de cookies preto', 'toppings'),
  ('Recheio de leitinho', 'toppings')
ON CONFLICT (id) DO UPDATE 
SET name = EXCLUDED.name,
    category_id = EXCLUDED.category_id;