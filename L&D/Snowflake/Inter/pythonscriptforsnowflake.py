import snowflake.connector

# Connect to Snowflake
conn = snowflake.connector.connect(
    user='jaycuts',
    password='Rony001',
    account='wv98871.central-india.azure',
    warehouse='my_warehouse',
    database='raw',
    schema='jaffle_shop'
)

# Execute a query
cursor = conn.cursor()
cursor.execute("SELECT * FROM my_table")
for row in cursor:
    print(row)

# Close the connection
cursor.close()
conn.close()
