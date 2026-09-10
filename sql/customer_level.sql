WITH order_values AS (
    SELECT order_id, SUM(price) AS order_value
    FROM order_items
    GROUP BY order_id
),
customer_orders AS (
    SELECT
        c.customer_unique_id,
        o.order_id,
        o.order_purchase_timestamp,
        ov.order_value,
        MIN(o.order_purchase_timestamp) OVER (
            PARTITION BY c.customer_unique_id
        ) AS first_purchase_ts
    FROM orders o
    JOIN customers c    ON o.customer_id = c.customer_id
    JOIN order_values ov ON o.order_id = ov.order_id
    WHERE o.order_status = 'delivered'
),
customer_base AS (
    SELECT
        customer_unique_id,
        MIN(order_purchase_timestamp) AS first_purchase_date,
        MAX(order_purchase_timestamp) AS last_purchase_date,
        COUNT(DISTINCT order_id)      AS frequency,
        SUM(order_value)              AS monetary,
        -- Repeat only if a later order came MORE than a day after the first.
        -- Same-day extra orders are split multi-seller baskets, not return visits.
        MAX(CASE
                WHEN JULIANDAY(order_purchase_timestamp)
                     - JULIANDAY(first_purchase_ts) > 1
                THEN 1 ELSE 0
            END) AS is_repeat_customer,
        -- Naive definition, kept for comparison in the write-up
        CASE WHEN COUNT(DISTINCT order_id) > 1 THEN 1 ELSE 0 END AS is_repeat_naive
    FROM customer_orders
    GROUP BY customer_unique_id
),
with_recency AS (
    SELECT
        *,
        CAST(
            JULIANDAY((SELECT MAX(order_purchase_timestamp) FROM orders)) + 1
            - JULIANDAY(last_purchase_date)
        AS INTEGER) AS recency_days
    FROM customer_base
)
SELECT
    customer_unique_id,
    first_purchase_date,
    last_purchase_date,
    recency_days,
    frequency,
    monetary,
    is_repeat_customer,
    is_repeat_naive,
    NTILE(4) OVER (ORDER BY monetary ASC)      AS monetary_quartile,
    NTILE(4) OVER (ORDER BY recency_days DESC) AS recency_quartile
FROM with_recency;