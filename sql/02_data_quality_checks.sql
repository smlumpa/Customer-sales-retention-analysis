-- Data quality checks for the three source tables.

-- Duplicate customer IDs
SELECT customer_id, COUNT(*) AS row_count
FROM `YOUR_PROJECT.customer_sales_retention.customers`
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- Duplicate order IDs
SELECT order_id, COUNT(*) AS row_count
FROM `YOUR_PROJECT.customer_sales_retention.orders`
GROUP BY order_id
HAVING COUNT(*) > 1;

-- Duplicate product IDs
SELECT product_id, COUNT(*) AS row_count
FROM `YOUR_PROJECT.customer_sales_retention.products`
GROUP BY product_id
HAVING COUNT(*) > 1;

-- Orders without a matching customer
SELECT o.*
FROM `YOUR_PROJECT.customer_sales_retention.orders` o
LEFT JOIN `YOUR_PROJECT.customer_sales_retention.customers` c
  ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- Orders without a matching product
SELECT o.*
FROM `YOUR_PROJECT.customer_sales_retention.orders` o
LEFT JOIN `YOUR_PROJECT.customer_sales_retention.products` p
  ON o.product_id = p.product_id
WHERE p.product_id IS NULL;

-- Basic validity checks
SELECT *
FROM `YOUR_PROJECT.customer_sales_retention.orders`
WHERE quantity <= 0
   OR order_value < 0
   OR discount_amount < 0;

-- Chronology checks: both queries should return zero rows after repair.
SELECT o.*
FROM `YOUR_PROJECT.customer_sales_retention.orders` o
JOIN `YOUR_PROJECT.customer_sales_retention.customers` c
  ON o.customer_id = c.customer_id
WHERE o.order_date < c.signup_date;

SELECT o.*
FROM `YOUR_PROJECT.customer_sales_retention.orders` o
JOIN `YOUR_PROJECT.customer_sales_retention.customers` c
  ON o.customer_id = c.customer_id
WHERE o.order_date > c.last_active_date;
