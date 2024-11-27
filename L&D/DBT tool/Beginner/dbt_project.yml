-- snapshots/my_snapshot.sql
{% snapshot my_snapshot %}

    {{
        config(
          target_schema='snapshots',  -- schema where the snapshot will be stored
          unique_key='id',            -- unique key to track changes in the table
          strategy='timestamp',        -- Timestamp strategy for capturing changes
          updated_at='_ETL_LOADED_AT'   -- columns to check for changes, ['*'] checks all columns
        )
    }}

    select * from {{ source('jaffle_shop', 'orders') }}


{% endsnapshot %}
