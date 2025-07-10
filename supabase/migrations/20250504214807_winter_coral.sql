/*
  # Update products list
  
  1. Changes
    - Remove 'Cereja' and 'Cupuaçu' from fruits
    - Fix 'Tampas de 5000ml' to 'Tampas de 500ml'
*/

-- Delete products we want to remove
DELETE FROM products 
WHERE name IN ('Cereja', 'Cupuaçu')
AND category_id = 'fruits';

-- Update the tampas name
UPDATE products 
SET name = 'Tampas de 500ml'
WHERE name = 'Tampas de 5000ml'
AND category_id = 'packages';