{% snapshot snp_customer %}
    {{
        config(
          target_schema='snapshots',
          unique_key='customerId',
          strategy='check',
          check_cols='all'
        )
    }}

    select *
    from '/tmp/customer.csv'
{% endsnapshot %}