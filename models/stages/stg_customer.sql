{{ 
    config(
        enabled=true
        )
}}

SELECT 
    customerID,
    customerName,
    contactNumber,
    Email,
    loyaltyStatus,
    RegionName AS regionName,
    flagActive,
    dbt_scd_id,
    dbt_valid_from,
    CASE
        WHEN flagActive = TRUE THEN dbt_valid_to
        ELSE NOW()
    END AS dbt_valid_to,
    dbt_updated_at
FROM {{ ref('snp_customer') }}