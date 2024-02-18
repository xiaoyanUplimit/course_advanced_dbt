

WITH

-- Import CTEs
-- Get raw monthly subscriptions
monthly_subscriptions AS (
    SELECT
        subscription_id,
        user_id,
        starts_at,
        ends_at,
        plan_name,
        pricing,
        DATE(DATE_TRUNC('month', starts_at)) AS start_month,
        DATE(DATE_TRUNC('month', ends_at)) AS end_month
    FROM
   {{ ref('dim_subscriptions') }}
     --   {{ ref('unit_test_input_subs') }}
    WHERE
        billing_period = 'monthly'
),

-- Use the dates spine to generate a list of months
months AS (
    SELECT
        calendar_date AS date_month
    FROM
       {{ ref('int_dates') }}
       --  {{ ref('unit_test_input_int_dates') }}
    WHERE
        day_of_month = 1
),




    SELECT
        subscription_id,
        user_id,
        plan_name,
        pricing AS monthly_amount,
        starts_at,
        ends_at,
        {{ get_month_start('starts_at') }} AS start_month,

        CASE
            WHEN {{ get_month_start('starts_at') }} = {{ get_month_start('ends_at') }} THEN {{ add_months(get_month_start('ends_at'), 1) }}
            WHEN ends_at IS NULL THEN {{ add_months(get_month_start('current_date'), 1) }}
            ELSE {{ get_month_start('ends_at') }}
        END AS end_month
    FROM
        monthly_subscriptions
