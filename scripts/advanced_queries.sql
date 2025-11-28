scripts/advanced_queries.sql

-- =============================================
-- ADVANCED ECOMMERCE ANALYTICS QUERIES
-- =============================================

USE ecommerce_portfolio;

-- 1. REVENUE BY CATEGORY (BAR CHART)
SELECT 
    c.category_name,
    ROUND(COALESCE(SUM(oi.quantity * oi.unit_price), 0), 2) AS Revenue
FROM categories c
LEFT JOIN products p ON c.category_id = p.category_id
LEFT JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY c.category_id
ORDER BY Revenue DESC;

-- 2. TOP CUSTOMERS (TABLE DATA)
SELECT 
    c.first_name,
    c.city,
    COUNT(o.order_id) AS Orders,
    SUM(o.total_amount) AS Revenue
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id
ORDER BY Revenue DESC;

-- 3. PRODUCT RANKING (WINDOW FUNCTION)
SELECT 
    p.product_name,
    p.price,
    p.stock_quantity,
    RANK() OVER (ORDER BY p.price DESC) AS Price_Rank
FROM products p
ORDER BY Price_Rank;

-- 4. INVENTORY DASHBOARD
SELECT 
    c.category_name,
    COUNT(p.product_id) AS Products,
    SUM(p.stock_quantity) AS Total_Stock
FROM categories c
LEFT JOIN products p ON c.category_id = p.category_id
GROUP BY c.category_id;


Add advanced SQL analytics queries 
