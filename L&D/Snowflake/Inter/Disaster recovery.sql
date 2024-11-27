
-Create a Database to Replicate
CREATE DATABASE my_sales_data;

-- To allow replication to another account
GRANT IMPORTED PRIVILEGES ON DATABASE my_sales_data TO ACCOUNT target_account;

-- Set data retention time for replication
ALTER DATABASE my_sales_data SET DATA_RETENTION_TIME_IN_DAYS = 1;

-- Create a database from the replicated data
CREATE DATABASE my_sales_data_replica CLONE my_sales_data AT 'wv98871.central-india.azure';

-- Check the replication status
SHOW REPLICATION ACCOUNTS;

-- Enable account replication for your account
ALTER ACCOUNT SET REPLICATION = TRUE;

-- Create a secondary account in a different region
CREATE ACCOUNT my_account_replica AS REPLICA OF "wv98871.central-india.azure";

-- Promote the replica account to primary during failure
ALTER ACCOUNT my_account_replica SET PRIMARY = TRUE;

-- Restore control to the primary account once it is back online
ALTER ACCOUNT primary_account SET PRIMARY = TRUE;

-- Set a Time Travel data retention period for the database
ALTER DATABASE my_sales_data SET DATA_RETENTION_TIME_IN_DAYS = 30;

-- Query data as it existed at a specific time in the past
SELECT * FROM my_sales_data.orders AT (TIMESTAMP => '2024-10-01 12:00:00');

-- Restore a table that was accidentally dropped within the retention period
UNDROP TABLE orders;

-- Clone a table or database at a specific point in time
CREATE TABLE orders_clone CLONE my_sales_data.orders AT (OFFSET => -60*60*24);  -- Clone data from 24 hours ago

-- Define a warehouse with minimum and maximum cluster counts
CREATE WAREHOUSE my_compute_warehouse
  WITH WAREHOUSE_SIZE = 'X-LARGE'
  MIN_CLUSTER_COUNT = 1
  MAX_CLUSTER_COUNT = 5
  AUTO_SUSPEND = 60
  AUTO_RESUME = TRUE;

-- Modify the cluster counts for better load management
ALTER WAREHOUSE my_compute_warehouse
  SET MIN_CLUSTER_COUNT = 2
  MAX_CLUSTER_COUNT = 10;

-- Check the current status of the clusters
SHOW WAREHOUSES LIKE 'my_compute_warehouse';

-- Suspend the warehouse for maintenance
ALTER WAREHOUSE my_compute_warehouse SUSPEND;
-- Resume the warehouse for operation
ALTER WAREHOUSE my_compute_warehouse RESUME;
