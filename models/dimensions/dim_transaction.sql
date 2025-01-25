{{ config(
    enabled=true
) }}

WITH product AS (
  SELECT *
  FROM {{ ref('stg_product') }} 
  WHERE dbt_valid_to IS NULL
),
transactions AS (
  SELECT
    t.transactionId,
    t.customerId,
    p.productId,
    p.productName,
    p.description,
    t.amount,
    t.transactionDate,
    p.discount,
    p.price,
    p.price - (p.price * (p.discount / 100.0)) AS finalPrice,
    p.dbt_valid_from,
    p.dbt_valid_to
  FROM
    {{ ref('stg_transaction') }} t
  JOIN
    product p ON t.productId = p.productId
)

SELECT
  dt.transactionId,
  dt.customerId,
  dt.productId,
  dt.productName,
  dt.description,
  dt.amount,
  dt.price,
  (dt.discount / 100.0) as dicount,
  SUM(dt.finalPrice) * dt.amount AS finalPrice,
  dt.transactionDate
FROM
  transactions dt
GROUP BY
  dt.transactionId,
  dt.transactionDate,
  dt.customerId,
  dt.productId,
  dt.productName,
  dt.description,
  dt.amount,
  dt.price,
  dicount
ORDER BY
  dt.transactionDate,
  dt.customerId