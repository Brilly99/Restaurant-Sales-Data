/* View base tables */
SELECT * FROM customers;
SELECT * FROM managers;
SELECT * FROM payment_methods;
SELECT * FROM products;
SELECT * FROM sales;
SELECT * FROM order_items;

/* 1. Top 5 Selling Products by Quantity */
-- join order_items and products
-- sum(quantity)
-- group by and order by
SELECT
    p.product_id,
    p.product_name,
    SUM(oi.quantity) AS total_quantity_sold
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
WHERE oi.quantity > 0
GROUP BY p.product_id, p.product_name
ORDER BY total_quantity_sold DESC
LIMIT 5;


/* 2. Total Revenue by Product Category */
-- join order_items and products
-- sum(price * quantity)
-- group by category
SELECT 
    p.category,
    SUM(p.price * oi.quantity) AS total_revenue
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY p.category
ORDER BY total_revenue DESC;


/* 3. Monthly Sales Trend (for 2024) */
-- join order_items and products
-- sum(price * quantity)
-- extract month/year from sale_date
-- filter year = 2024
SELECT 
    DATE_TRUNC('month', s.order_date) AS month,
    SUM(p.price * oi.quantity) AS total_revenue
FROM sales s
JOIN order_items oi
    ON s.order_id = oi.order_id
JOIN products p
    ON p.product_id = oi.product_id
WHERE s.order_date BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY DATE_TRUNC('month', s.order_date)
ORDER BY month;


/* 4. Manager Performance by Revenue */
-- join sales, order_items, products, and managers
-- sum(price * quantity)
-- group by manager
SELECT
    m.manager_name,
    SUM(p.price * oi.quantity) AS total_revenue
FROM managers m
JOIN sales s
    ON m.manager_id = s.manager_id
JOIN order_items oi
    ON s.order_id = oi.order_id
JOIN products p
    ON p.product_id = oi.product_id
GROUP BY m.manager_name
ORDER BY total_revenue DESC;


/* 5. Payment Method Distribution */
-- join sales and payment_methods
-- count number of sales per payment method
SELECT
    pm.method_name AS payment_method,
    COUNT(*) AS total_transactions
FROM sales s
JOIN payment_methods pm
    ON s.payment_id = pm.payment_id
GROUP BY pm.method_name
ORDER BY total_transactions DESC;


/* 6. Top 5 Customers by Spending */
-- join sales, order_items, products, customers
-- sum(price * quantity)
-- group by customer
SELECT
    c.name AS customer_name,
    SUM(p.price * oi.quantity) AS total_spent
FROM customers c
JOIN sales s
    ON c.customer_id = s.customer_id
JOIN order_items oi
    ON s.order_id = oi.order_id
JOIN products p
    ON p.product_id = oi.product_id
GROUP BY c.customer_id, c.name
ORDER BY total_spent DESC
LIMIT 5;


/* 7. Average Order Value (AOV) */
-- sum(price * quantity) per order
-- average of these sums
SELECT
    ROUND(AVG(order_total), 2) AS average_order_value
FROM (
    SELECT 
        s.order_id,
        SUM(p.price * oi.quantity) AS order_total
    FROM sales s
    JOIN order_items oi
        ON s.order_id = oi.order_id
    JOIN products p
        ON p.product_id = oi.product_id
    GROUP BY s.order_id
) AS order_totals;


/* 8. Most Popular Product in Each Category */
-- join order_items and products
-- sum(quantity)
-- rank within each category
WITH ranked_products AS (
    SELECT
        p.category,
        p.product_name,
        SUM(oi.quantity) AS total_quantity_sold,
        RANK() OVER (PARTITION BY p.category ORDER BY SUM(oi.quantity) DESC) AS rnk
    FROM products p
    JOIN order_items oi
        ON p.product_id = oi.product_id
    GROUP BY p.category, p.product_name
)
SELECT category, product_name, total_quantity_sold
FROM ranked_products
WHERE rnk = 1;


/* 9. City-wise Sales Analysis */
-- join sales, customers, order_items, products
-- sum(price * quantity)
-- group by city
SELECT
    c.city,
    SUM(p.price * oi.quantity) AS total_revenue
FROM customers c
JOIN sales s
    ON c.customer_id = s.customer_id
JOIN order_items oi
    ON s.order_id = oi.order_id
JOIN products p
    ON p.product_id = oi.product_id
GROUP BY c.city
ORDER BY total_revenue DESC;


/* 10. Revenue Contribution per Manager Branch */
-- join sales, order_items, products, managers
-- sum revenue per manager
-- calculate % contribution
WITH manager_revenue AS (
    SELECT
        m.manager_id,
        m.manager_name,
        SUM(p.price * oi.quantity) AS total_revenue
    FROM managers m
    JOIN sales s
        ON m.manager_id = s.manager_id
    JOIN order_items oi
        ON s.order_id = oi.order_id
    JOIN products p
        ON p.product_id = oi.product_id
    GROUP BY m.manager_id, m.manager_name
),
total_revenue AS (
    SELECT SUM(total_revenue) AS grand_total
    FROM manager_revenue
)
SELECT
    mr.manager_id,
    mr.manager_name,
    mr.total_revenue,
    ROUND(mr.total_revenue * 100.0 / NULLIF(tr.grand_total,0), 2) AS revenue_percentage
FROM manager_revenue mr
CROSS JOIN total_revenue tr
ORDER BY revenue_percentage DESC;
