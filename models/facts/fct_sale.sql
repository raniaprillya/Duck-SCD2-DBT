{{ config(
    enabled=true
) }}
WITH
customer_total_spend AS (
    SELECT
        scust.customerId,
        scust.customerName,
        scust.regionName,
        SUM(transactions.finalPrice) AS totalSpend
    FROM
        {{ ref('dim_customer') }} scust
    JOIN
        {{ ref('dim_transaction') }} transactions ON scust.customerId = transactions.customerId
    WHERE scust.dbt_valid_to > NOW() 
    GROUP BY
        scust.customerId,
        scust.customerName,
        scust.regionName
)

SELECT * FROM customer_total_spend