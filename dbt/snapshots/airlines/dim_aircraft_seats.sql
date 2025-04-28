{% snapshot dim_aircraft_seats %}

{% set snapshot_schema = target.schema + '_snapshot' %}

{{

    config(
        target_schema = snapshot_schema,
        unique_key = 'aircraft_code || \'__\' || seat_no',
        strategy = 'check',
        check_cols = ['fare_conditions']
    )

}}

select 
    aircraft_code, 
    seat_no, 
    fare_conditions,
    case
        when count(*) over(partition by aircraft_code, seat_no) = 1 
        then null
        else now()::timestamp
    end as dbt_valid_from_custom
from {{ ref('stg_airlines__seats') }}

{% endsnapshot %}