-- models/customers.sql
SELECT
    customer_id,
    customer_name,
    customer_email
FROM {{ source('raffle', 'customers') }}
