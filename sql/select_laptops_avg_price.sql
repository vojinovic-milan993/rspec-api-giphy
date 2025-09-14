SELECT product_name
FROM products
WHERE product_type = 'laptop'
GROUP BY product_name
HAVING AVG(price) < 2000;
