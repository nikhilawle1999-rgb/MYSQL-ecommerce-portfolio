DROP DATABASE IF EXISTS ecommerce_portfolio;
CREATE DATABASE ecommerce_portfolio;
USE ecommerce_portfolio;
-- =============================================
-- COMPLETE ECOMMERCE DATABASE SETUP (ONE-CLICK)
-- =============================================

DROP DATABASE IF EXISTS ecommerce_portfolio;
CREATE DATABASE ecommerce_portfolio;
USE ecommerce_portfolio;

-- Disable safe updates
SET SQL_SAFE_UPDATES = 0;

-- 1. CREATE TABLES
CREATE TABLE categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT
);

CREATE TABLE suppliers (
    supplier_id INT PRIMARY KEY AUTO_INCREMENT,
    supplier_name VARCHAR(100) NOT NULL,
    contact_name VARCHAR(100),
    email VARCHAR(100),
    rating DECIMAL(3,2) DEFAULT 5.00
);

CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    city VARCHAR(50),
    state VARCHAR(50)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(200) NOT NULL,
    supplier_id INT,
    category_id INT,
    price DECIMAL(10,2) NOT NULL,
    stock_quantity INT DEFAULT 0,
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id),
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10,2) DEFAULT 0.00,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT DEFAULT 1,
    unit_price DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- 2. LOAD SAMPLE DATA
INSERT INTO categories (category_name, description) VALUES
('Electronics', 'Smartphones, laptops'),
('Clothing', 'Apparel & accessories'),
('Home', 'Furniture & decor'),
('Sports', 'Fitness equipment');

INSERT INTO suppliers (supplier_name, contact_name, email, rating) VALUES
('TechStore', 'Alice Johnson', 'alice@techstore.com', 4.8),
('FashionHub', 'Lisa Chen', 'lisa@fashion.com', 4.9),
('HomeDepot', 'Tom Wilson', 'tom@homedepot.com', 4.5);

INSERT INTO customers (first_name, last_name, email, city, state) VALUES
('John', 'Doe', 'john@email.com', 'New York', 'NY'),
('Jane', 'Smith', 'jane@email.com', 'Los Angeles', 'CA'),
('Mike', 'Johnson', 'mike@email.com', 'Chicago', 'IL'),
('Sarah', 'Wilson', 'sarah@email.com', 'Miami', 'FL');

INSERT INTO products (product_name, supplier_id, category_id, price, stock_quantity) VALUES
('iPhone 15', 1, 1, 999.99, 25),
('MacBook Pro', 1, 1, 2499.99, 10),
('Summer Dress', 2, 2, 89.99, 30),
('Coffee Table', 3, 3, 299.99, 15),
('Running Shoes', 1, 4, 149.99, 20);

INSERT INTO orders (customer_id, total_amount) VALUES
(1, 999.99),
(2, 89.99),
(3, 2499.99);

INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 999.99),
(2, 3, 1, 89.99),
(3, 2, 1, 2499.99);

-- 3. STORED PROCEDURE
DELIMITER //
CREATE PROCEDURE GetCustomerSummary(IN customer_email VARCHAR(100))
BEGIN
    SELECT 
        c.first_name, c.last_name,
        COUNT(o.order_id) as Total_Orders,
        COALESCE(SUM(o.total_amount), 0) as Total_Spent
    FROM customers c
    LEFT JOIN orders o ON c.customer_id = o.customer_id
    WHERE c.email = customer_email
    GROUP BY c.customer_id;
END //
DELIMITER ;

-- 4. VIEWS
CREATE VIEW sales_dashboard AS
SELECT c.first_name, c.city, COUNT(o.order_id) as Orders, SUM(o.total_amount) as Revenue
FROM customers c LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id;

-- 5. SUCCESS MESSAGE
SELECT '🎉 DATABASE CREATED SUCCESSFULLY!' as Status;
SELECT COUNT(*) as Tables_Created FROM information_schema.tables WHERE table_schema = 'ecommerce_portfolio';

