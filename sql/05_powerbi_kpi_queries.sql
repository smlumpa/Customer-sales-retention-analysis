-- KPI queries corresponding to the Customer Sales & Retention analysis.

-- Executive KPIs
SELECT
  SUM(IF(order_status = 'Completed', order_value, 0)) AS total_sales,
  COUNTIF(order_status = 'Completed') AS completed_orders,
  COUNT(DISTINCT IF(order_status = 'Completed', customer_id, NULL))
    AS purchasing_customers,
  SAFE_DIVIDE(
    SUM(IF(order_status = 'Completed', order_value, 0)),
    COUNTIF(order_status = 'Completed')
  ) AS average_order_value
FROM `YOUR_PROJECT.customer_sales_retention.orders`;

-- Customer status / churn distribution
SELECT
  churn_flag,
  COUNT(*) AS customers,
  ROUND(100 * SAFE_DIVIDE(COUNT(*), SUM(COUNT(*)) OVER()), 2)
    AS customer_percentage
FROM `YOUR_PROJECT.customer_sales_retention.customers`
GROUP BY churn_flag
ORDER BY customers DESC;

-- Sales by customer segment
SELECT
  c.customer_segment,
  SUM(IF(o.order_status = 'Completed', o.order_value, 0)) AS sales,
  COUNTIF(o.order_status = 'Completed') AS completed_orders
FROM `YOUR_PROJECT.customer_sales_retention.customers` c
LEFT JOIN `YOUR_PROJECT.customer_sales_retention.orders` o
  ON c.customer_id = o.customer_id
GROUP BY c.customer_segment
ORDER BY sales DESC;

-- Monthly sales trend
SELECT
  DATE_TRUNC(order_date, MONTH) AS month,
  SUM(order_value) AS sales,
  COUNT(*) AS completed_orders
FROM `YOUR_PROJECT.customer_sales_retention.orders`
WHERE order_status = 'Completed'
GROUP BY month
ORDER BY month;

-- Product/category performance
SELECT
  p.product_category,
  p.product_name,
  SUM(IF(o.order_status = 'Completed', o.order_value, 0)) AS sales,
  SUM(IF(o.order_status = 'Completed', o.quantity, 0)) AS units_sold
FROM `YOUR_PROJECT.customer_sales_retention.products` p
LEFT JOIN `YOUR_PROJECT.customer_sales_retention.orders` o
  ON p.product_id = o.product_id
GROUP BY p.product_category, p.product_name
ORDER BY sales DESC;

-- Acquisition-channel performance
SELECT
  c.acquisition_channel,
  COUNT(DISTINCT c.customer_id) AS customers,
  SUM(IF(o.order_status = 'Completed', o.order_value, 0)) AS sales
FROM `YOUR_PROJECT.customer_sales_retention.customers` c
LEFT JOIN `YOUR_PROJECT.customer_sales_retention.orders` o
  ON c.customer_id = o.customer_id
GROUP BY c.acquisition_channel
ORDER BY sales DESC;
