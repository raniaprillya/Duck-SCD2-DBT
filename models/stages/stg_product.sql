{{ 
    config(
        enabled=true
        )
}}

SELECT 
    *
FROM {{ ref('snp_product') }}