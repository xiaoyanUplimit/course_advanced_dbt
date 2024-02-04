{% macro rolling_average(column_name, partition_by, order_by='created_at', periods=7, alias_prefix='avg') %}
    avg( {{ column_name }} ) OVER (
                PARTITION BY {{ partition_by }}
                ORDER BY {{ order_by }}
                ROWS BETWEEN {{ periods - 1 }} PRECEDING AND CURRENT ROW
            ) AS {{ alias_prefix }}_{{ periods }}_periods_{{ column_name }}
{% endmacro %}
