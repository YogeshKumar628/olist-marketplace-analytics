SELECT
    o.order_id,
    c.customer_unique_id,
    c.customer_state,
    o.order_purchase_timestamp,
    SUM(oi.price) AS order_value,
    SUM(oi.freight_value) AS freight_value,
    COUNT(*) AS n_items,
    JULIANDAY(o.order_delivered_customer_date)
        - JULIANDAY(o.order_estimated_delivery_date) AS delivery_delay_days,
    JULIANDAY(o.order_delivered_customer_date)
        - JULIANDAY(o.order_purchase_timestamp) AS delivery_time_days
FROM orders o
JOIN customers c   ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
GROUP BY o.order_id;