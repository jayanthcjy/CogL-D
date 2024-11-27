
--Creating a Warehouse with Cost Optimization Settings
CREATE WAREHOUSE my_warehouse
  WITH WAREHOUSE_SIZE = 'XSMALL'  
  AUTO_SUSPEND = 60               
  AUTO_RESUME = TRUE              
  INITIALLY_SUSPENDED = TRUE;     

-- Creating a Resource Monitor
CREATE RESOURCE MONITOR my_monitor
  WITH CREDIT_QUOTA = 1000              
  TRIGGERS
  ON 80 PERCENT DO NOTIFY               
  ON 100 PERCENT DO SUSPEND;            

--Associating a Resource Monitor with a Warehouse
ALTER WAREHOUSE my_warehouse
  SET RESOURCE_MONITOR = my_monitor;

-- Querying Warehouse Credit Usage
SELECT 
    WAREHOUSE_NAME, 
    DATE_TRUNC('day', START_TIME) AS usage_day,
    SUM(CREDITS_USED) AS daily_credits
FROM SNOWFLAKE.ACCOUNT_USAGE.WAREHOUSE_METERING_HISTORY
WHERE START_TIME >= DATEADD('day', -30, CURRENT_DATE())
GROUP BY WAREHOUSE_NAME, usage_day
ORDER BY usage_day, WAREHOUSE_NAME;

--  Querying Storage Usage
SELECT 
    DATE_TRUNC('day', USAGE_DATE) AS usage_day,
    AVG(STORAGE_BYTES) / 1024 / 1024 / 1024 AS avg_storage_gb  
FROM SNOWFLAKE.ACCOUNT_USAGE.STORAGE_USAGE_HISTORY
WHERE USAGE_DATE >= DATEADD('day', -30, CURRENT_DATE())
GROUP BY usage_day
ORDER BY usage_day;

-- Querying High-Cost Queries
SELECT 
    QUERY_TEXT,
    WAREHOUSE_NAME,
    EXECUTION_STATUS,
    TOTAL_ELAPSED_TIME/1000 AS execution_time_s,  
    CREDITS_USED
FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY
WHERE START_TIME >= DATEADD('day', -30, CURRENT_DATE())
  AND CREDITS_USED IS NOT NULL
ORDER BY CREDITS_USED DESC
LIMIT 10;

--  Querying Data Transfers Across Regions
SELECT 
    QUERY_TEXT,
    DATABASE_NAME,
    WAREHOUSE_NAME,
    BYTES_SCANNED / 1024 / 1024 AS scanned_mb,  -- Convert bytes to MB
    BYTES_SENT_ACROSS_REGIONS / 1024 / 1024 AS cross_region_mb  -- Convert bytes to MB
FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY
WHERE BYTES_SENT_ACROSS_REGIONS > 0
  AND START_TIME >= DATEADD('day', -30, CURRENT_DATE())
ORDER BY cross_region_mb DESC;

--  Example of Cached Query Usage
SELECT 
    COUNT(*)
FROM my_table
WHERE status = 'ACTIVE';
