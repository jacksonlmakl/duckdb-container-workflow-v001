-- Load the PostgreSQL extension in DuckDB
INSTALL postgres;
LOAD postgres;

-- Create a sample table in DuckDB (replace with your actual DuckDB table)
CREATE OR REPLACE TABLE duckdb_sample_data AS 
SELECT 1 AS id, 'Product A' AS product_name, 29.99 AS price, 100 AS stock_quantity UNION ALL
SELECT 2, 'Product B', 49.99, 75 UNION ALL
SELECT 3, 'Product C', 19.99, 200 UNION ALL
SELECT 4, 'Product D', 99.99, 50 UNION ALL
SELECT 5, 'Product E', 9.99, 150;

-- Create a connection to your PostgreSQL database
CREATE OR REPLACE POSTGRES_CONNECTION pg_conn TO 
  'postgresql://jackson:jackson123@ls-2a7d4e4d9224e72ff5b761a4e80c658e526788a3.c4fmk2omyh2a.us-east-1.rds.amazonaws.com:5432/dbjackson';

-- Create PostgreSQL table that matches the DuckDB table schema
CREATE OR REPLACE TABLE pg_products AS 
  FROM postgres_query(
    'pg_conn', 
    'CREATE TABLE IF NOT EXISTS products (
      id INTEGER PRIMARY KEY,
      product_name VARCHAR(100) NOT NULL,
      price DECIMAL(10, 2) NOT NULL,
      stock_quantity INTEGER NOT NULL
    )'
  );

-- Copy data from DuckDB table to PostgreSQL
COPY duckdb_sample_data TO 
  postgres_scan(
    'pg_conn', 
    'products'
  );

-- Verify data was transferred correctly
SELECT * FROM postgres_query(
  'pg_conn', 
  'SELECT * FROM products ORDER BY id'
);

-- Close the connection
DROP POSTGRES_CONNECTION pg_conn;