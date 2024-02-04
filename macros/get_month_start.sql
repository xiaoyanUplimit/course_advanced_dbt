{% macro get_month_start(date_column) %}
    DATE_TRUNC('month', {{ date_column }})
{% endmacro %}

{% macro add_months(date_column, num_months) %}
    DATEADD('month', {{ num_months }}, {{ date_column }})
{% endmacro %}
