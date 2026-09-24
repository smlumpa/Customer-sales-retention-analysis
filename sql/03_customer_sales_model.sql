-- Analytics-ready customer sales model for Power BI.
-- Completed orders are used for realised sales metrics.
-- Returned/cancelled orders remain available in the source orders table.

CREATE OR REPLACE VIEW `YOUR_PROJECT.customer_sales_retention.vw_customer_sales` AS
SELECT
  o.order_id,
  o.order_date,
  EXTRACT(YEAR FROM o.order_date) AS order_year,
  EXTRACT(MONTH FROM o.order_date) AS order_month,
  FORMAT_DATE('%Y-%m', o.order_date) AS year_month,

  c.customer_id,
  c.customer_name,
  c.customer_segment,
  c.signup_date,
  c.country,
  c.acquisition_channel,
  c.last_active_date,
  c.churn_flag,

  p.product_id,
  p.product_name,
  p.product_category,
  p.unit_price,

  o.quantity,
  o.order_value,
  o.discount_amount,
  o.order_status,
  o.payment_method,

  CASE WHEN o.order_status = 'Completed' THEN o.order_value ELSE 0 END
    AS completed_sales,
  CASE WHEN o.order_status = 'Completed' THEN o.quantity ELSE 0 END
    AS completed_quantity,
  CASE WHEN o.order_status = 'Completed' THEN o.discount_amount ELSE 0 END
    AS completed_discount

FROM `YOUR_PROJECT.customer_sales_retention.orders` o
LEFT JOIN `YOUR_PROJECT.customer_sales_retention.customers` c
  ON o.customer_id = c.customer_id
LEFT JOIN `YOUR_PROJECT.customer_sales_retention.products` p
  ON o.product_id = p.product_id;
