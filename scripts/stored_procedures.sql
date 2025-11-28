USE ecommerce_portfolio;

-- 1. TEST STORED PROCEDURE
CALL GetCustomerSummary('john@email.com');

-- 2. TEST SALES DASHBOARD
SELECT * FROM sales_dashboard;

-- 3. LOW STOCK ALERT
SELECT product_name, stock_quantity 
FROM products 
WHERE stock_quantity < 15;
