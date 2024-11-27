-- Use the specified database
USE DATABASE my_database;

--Create the original table in the production schema
CREATE TABLE production.sales_data (
    sale_id INT,
    sale_amount DECIMAL(10, 2),
    sale_date DATE
);

-- Insert data into the original table
INSERT INTO production.sales_data VALUES 
    (1, 100.00, '2024-11-01'),
    (2, 200.00, '2024-11-02'),
    (3, 150.00, '2024-11-03');

-- Create a clone of the original table in the testing schema
CREATE TABLE testing.sales_data_clone CLONE production.sales_data;

--  Select data from the clone to verify the cloned content
SELECT * FROM testing.sales_data_clone;

--  Insert a new record into the original table
INSERT INTO production.sales_data VALUES (4, 250.00, '2024-11-04');

--  Delete a record from the cloned table
DELETE FROM testing.sales_data_clone WHERE sale_id = 1;

-- Verify data in the original and cloned tables
-- Select from the original table
SELECT * FROM production.sales_data;

-- Select from the cloned table after modification
SELECT * FROM testing.sales_data_clone;
