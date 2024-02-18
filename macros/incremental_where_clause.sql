{ % macro incremental_where_clause (column_name, lookback_window = 3 , interval_type = 'days') %}

{ % if is_incremental() %}
WHERE  {{ column_name }} > (SELECT MAX({{ column_name }} ) FROM {{this}}) -INTERVAL '{{ lookback_window}} {{interval_type}}'
{ % endif %}

{% endmacro %}