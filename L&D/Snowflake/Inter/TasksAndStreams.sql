-- File: setup_streams_and_tasks.sql

--  Create the main table to store sales data
CREATE OR REPLACE TABLE sales_data (
    sale_id INT,
    sale_date DATE,
    amount DECIMAL(10,2),
    region STRING
);

-- Insert initial data into the sales_data table
INSERT INTO sales_data VALUES
    (1, '2024-01-01', 100.00, 'East'),
    (2, '2024-01-02', 150.00, 'West');

--  Create a stream to track changes in the sales_data table
CREATE OR REPLACE STREAM sales_data_stream ON TABLE sales_data;

--  Insert new data to simulate changes that will be captured by the stream
INSERT INTO sales_data VALUES
    (3, '2024-01-03', 200.00, 'North'),
    (4, '2024-01-04', 250.00, 'South');

--  Create the target table for storing aggregated sales data by region
CREATE OR REPLACE TABLE aggregated_sales (
    region STRING,
    total_sales DECIMAL(10,2)
);

--  Create a task that processes the data captured by sales_data_stream
CREATE OR REPLACE TASK process_sales_data
  WAREHOUSE = my_warehouse  -- Replace with your actual warehouse name
  SCHEDULE = '1 hour'  -- Schedule the task to run every hour
AS
  MERGE INTO aggregated_sales AS target
  USING (
      SELECT region, SUM(amount) AS total_sales
      FROM sales_data_stream
      GROUP BY region
  ) AS source
  ON target.region = source.region
  WHEN MATCHED THEN 
    UPDATE SET total_sales = target.total_sales + source.total_sales
  WHEN NOT MATCHED THEN 
    INSERT (region, total_sales) VALUES (source.region, source.total_sales);

--  Start the task to activate the schedule
ALTER TASK process_sales_data RESUME;


