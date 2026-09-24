# Data dictionary

## Customers

| Field | Meaning |
|---|---|
| `customer_id` | Synthetic unique customer identifier |
| `customer_name` | Fictitious sample customer name |
| `customer_segment` | Commercial segment assigned to the customer |
| `signup_date` | Repaired enrolment date, never later than first activity |
| `country` | Customer market |
| `acquisition_channel` | Marketing channel attributed to acquisition |
| `last_active_date` | Most recent recorded activity date |
| `churn_flag` | Source status: Active, At Risk or Churned |

## Orders

| Field | Meaning |
|---|---|
| `order_id` | Synthetic unique order identifier |
| `customer_id` | Foreign key to Customers |
| `product_id` | Foreign key to Products |
| `order_date` | Transaction date |
| `quantity` | Units recorded on the order |
| `order_value` | Recorded order value |
| `order_status` | Completed, Cancelled or Returned |
| `discount_amount` | Discount recorded on the order |
| `payment_method` | Sample payment method |

## Products

| Field | Meaning |
|---|---|
| `product_id` | Synthetic unique product identifier |
| `product_name` | Product description |
| `product_category` | Reporting category |
| `unit_price` | Reference unit price |
