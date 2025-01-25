{% snapshot snp_transaction %}
    {{
        config(
          target_schema='snapshots',
          unique_key='id',
          strategy='check',
          check_cols=['id'] 
        )
    }}

    select *
    from '/tmp/transaction.csv'
{% endsnapshot %}