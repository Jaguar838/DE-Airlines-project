{% snapshot dim_aircrafts %}

{% set snapshot_schema = target.schema + '_snapshot' %}

{{

    config(
        target_schema = snapshot_schema,
        unique_key = 'aircraft_code',
        strategy = 'check',
        check_cols = ['model']
    )

}}

select 
    aircraft_code, 
    model,
    case
        when count(*) over(partition by aircraft_code) = 1 
        then null
        else now()::timestamp
    end as dbt_valid_from_custom
from {{ ref('stg_dict__aircrafts') }}

{% endsnapshot %}