-- macros/my_macros.sql

{% macro select_all(table_name) %}
    select *
    from {{ table_name }}
{% endmacro %}

{% macro select_by_column(table_name, column_name, value) %}
    select *
    from {{ table_name }}
    where {{ column_name }} = '{{ value }}'
{% endmacro %}
