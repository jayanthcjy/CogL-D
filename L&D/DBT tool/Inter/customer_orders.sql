-- models/customer_orders.sql
WITH orders AS (
    SELECT * FROM {{ ref('orders') }}
),

customers AS (
    SELECT * FROM {{ ref('customers') }}
)

SELECT
    o.order_id,
    o.order_date,
    o.total_amount,
    c.customer_id,
    c.customer_name,
    c.customer_email
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
