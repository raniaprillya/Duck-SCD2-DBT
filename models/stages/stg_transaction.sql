{{ 
    config(
        enabled=true
        )
}}

SELECT 
    transactionId,
    customerId,
    productId,
    amount,
    transactionDate
FROM {{ ref('snp_transaction') }}