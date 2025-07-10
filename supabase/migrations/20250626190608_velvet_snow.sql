-- Remove "Creme de cookies" from toppings
DELETE FROM products 
WHERE name = 'Creme de cookies' 
AND category_id = 'toppings';