-- Customer Sales & Retention Analysis
-- BigQuery table definitions
-- Replace `YOUR_PROJECT.customer_sales_retention` with your own project and dataset.

CREATE TABLE IF NOT EXISTS `YOUR_PROJECT.customer_sales_retention.customers` (
  customer_id STRING,
  customer_name STRING,
  customer_segment STRING,
  signup_date DATE,
  country STRING,
  acquisition_channel STRING,
  last_active_date DATE,
  churn_flag STRING
);

CREATE TABLE IF NOT EXISTS `YOUR_PROJECT.customer_sales_retention.orders` (
  order_id STRING,
  customer_id STRING,
  product_id STRING,
  order_date DATE,
  quantity INT64,
  order_value NUMERIC,
  order_status STRING,
  discount_amount NUMERIC,
  payment_method STRING
);

CREATE TABLE IF NOT EXISTS `YOUR_PROJECT.customer_sales_retention.products` (
  product_id STRING,
  product_name STRING,
  product_category STRING,
  unit_price NUMERIC
);
