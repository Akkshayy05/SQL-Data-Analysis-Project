/* DATABASE CREATION , TABLE CREATION AND VALUE INSERTION*/

-- Create schema
CREATE SCHEMA gold;

-- Create tables
CREATE TABLE gold.dim_customers (
    customer_key SERIAL PRIMARY KEY,
    customer_id INT,
    customer_number VARCHAR(50),
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    country VARCHAR(50),
    marital_status VARCHAR(50),
    gender VARCHAR(50),
    birthdate DATE,
    create_date DATE
);

CREATE TABLE gold.dim_products (
    product_key SERIAL PRIMARY KEY,
    product_id INT,
    product_number VARCHAR(50),
    product_name VARCHAR(50),
    category_id VARCHAR(50),
    category VARCHAR(50),
    subcategory VARCHAR(50),
    maintenance VARCHAR(50),
    cost INT,
    product_line VARCHAR(50),
    start_date DATE
);

CREATE TABLE gold.fact_sales (
    order_number VARCHAR(50),
    product_key INT REFERENCES gold.dim_products(product_key),
    customer_key INT REFERENCES gold.dim_customers(customer_key),
    order_date DATE,
    shipping_date DATE,
    due_date DATE,
    sales_amount INT,
    quantity SMALLINT,
    price INT
);



COPY gold.dim_customers(customer_id, customer_number, first_name, last_name, country, marital_status, gender, birthdate, create_date)
FROM 'D:/sql/sql-data-analytics-project/datasets/csv-files/gold.dim_customers.csv'
DELIMITER ',' CSV HEADER;



COPY gold.dim_products(
    product_id,
    product_number,
    product_name,
    category_id,
    category,
    subcategory,
    maintenance,
    cost,
    product_line,
    start_date
)
FROM 'D:/sql/sql-data-analytics-project/datasets/csv-files/gold.dim_products.csv'
DELIMITER ',' 
CSV HEADER;




COPY gold.fact_sales(
    order_number,
    product_key,
    customer_key,
    order_date,
    shipping_date,
    due_date,
    sales_amount,
    quantity,
    price
)
FROM 'D:/sql/sql-data-analytics-project/datasets/csv-files/gold.fact_sales.csv'
DELIMITER ',' 
CSV HEADER;
















