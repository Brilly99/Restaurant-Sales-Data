-- Tabel Customers
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    city VARCHAR(50)
);

-- Tabel Managers
CREATE TABLE managers (
    manager_id INT PRIMARY KEY,
    name VARCHAR(100),
    branch VARCHAR(50)
);

-- Tabel Payment Methods
CREATE TABLE payment_methods (
    payment_id INT PRIMARY KEY,
    method_name VARCHAR(50)
);

-- Tabel Products
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2)
);

-- Tabel Sales (Orders)
CREATE TABLE sales (
    order_id INT PRIMARY KEY,
    order_date DATE,
    customer_id INT,
    manager_id INT,
    payment_id INT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (manager_id) REFERENCES managers(manager_id),
    FOREIGN KEY (payment_id) REFERENCES payment_methods(payment_id)
);

-- Tabel Order Items (detail penjualan)
CREATE TABLE order_items (
    order_id INT,
    product_id INT,
    quantity INT,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES sales(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
