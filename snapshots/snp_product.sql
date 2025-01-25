{% snapshot snp_product %}
    {{
        config(
          target_schema='snapshots',
          unique_key='productId',
          strategy='check',
          check_cols='all'
        )
    }}

    select *
    from '/tmp/product.csv'
{% endsnapshot %}