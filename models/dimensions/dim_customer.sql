{{ 
    config(
        enabled=true
    )
}}

WITH 
first_record AS (
    SELECT
        customerID AS customerId,
        min(dbt_valid_from)::TIMESTAMP AS created_time
    FROM
        {{ ref('stg_customer') }}
    GROUP BY
        customerID
),

cust AS (
    SELECT
        customerID AS customerId,
        regionName,
        customerName,
        contactNumber,	
        Email,	
        loyaltyStatus,
        CAST(dbt_valid_from AS TIMESTAMP) AS dbt_updated_at,	
        CAST(COALESCE(dbt_valid_to, '2999-12-31') AS TIMESTAMP) AS dbt_valid_to
    FROM
        {{ ref('stg_customer') }}
),

scust AS (
    SELECT
        cust.*,  -- Selecting all columns from the 'cust' CTE
        first_record.created_time  -- Adding the '_created_datetime' from 'first_record'
    FROM
        cust
    LEFT JOIN first_record
        ON cust.customerId = first_record.customerId
)

SELECT
    *
FROM
    scust
WHERE dbt_valid_to > NOW()