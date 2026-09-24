-- Customer-level retention and value summary.

CREATE OR REPLACE VIEW `YOUR_PROJECT.customer_sales_retention.vw_customer_retention_summary` AS
SELECT
  c.customer_id,
  c.customer_name,
  c.customer_segment,
  c.country,
  c.acquisition_channel,
  c.signup_date,
  c.last_active_date,
  c.churn_flag,

  COUNTIF(o.order_status = 'Completed') AS completed_orders,
  COALESCE(SUM(IF(o.order_status = 'Completed', o.quantity, 0)), 0)
    AS units_purchased,
  COALESCE(SUM(IF(o.order_status = 'Completed', o.order_value, 0)), 0)
    AS lifetime_sales,
  COALESCE(SUM(IF(o.order_status = 'Completed', o.discount_amount, 0)), 0)
    AS total_discount,
  AVG(IF(o.order_status = 'Completed', o.order_value, NULL))
    AS average_order_value,
  MIN(IF(o.order_status = 'Completed', o.order_date, NULL))
    AS first_order_date,
  MAX(IF(o.order_status = 'Completed', o.order_date, NULL))
    AS last_order_date,
  DATE_DIFF(
    c.last_active_date,
    MAX(IF(o.order_status = 'Completed', o.order_date, NULL)),
    DAY
  ) AS days_from_last_order_to_last_activity

FROM `YOUR_PROJECT.customer_sales_retention.customers` c
LEFT JOIN `YOUR_PROJECT.customer_sales_retention.orders` o
  ON c.customer_id = o.customer_id
GROUP BY
  c.customer_id, c.customer_name, c.customer_segment, c.country,
  c.acquisition_channel, c.signup_date, c.last_active_date, c.churn_flag;
