WITH seller_revenue AS (
    SELECT
        s.seller_state,
        s.seller_id,
        SUM(oi.price) AS total_revenue
    FROM sellers s
    JOIN order_items oi ON s.seller_id = oi.seller_id
    JOIN orders o       ON oi.order_id = o.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY s.seller_state, s.seller_id
),
ranked_sellers AS (
    SELECT
        seller_state,
        seller_id,
        total_revenue,
        RANK() OVER (PARTITION BY seller_state ORDER BY total_revenue DESC) AS state_rank
    FROM seller_revenue
)
SELECT *
FROM ranked_sellers
WHERE state_rank <= 3
ORDER BY seller_state ASC, state_rank ASC;