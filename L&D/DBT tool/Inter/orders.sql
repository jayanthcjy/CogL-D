-- models/orders.sql
SELECT
    order_id,
    customer_id,
    order_date,
    total_amount
FROM {{ source('raffle', 'orders') }}
