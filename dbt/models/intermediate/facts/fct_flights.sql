{{
    config(
        materialized = 'incremental',
        unique_key = 'flight_id'
    )
}}
select
    flight_id, 
    flight_no, 
    scheduled_departure, 
    scheduled_arrival, 
    departure_airport, 
    arrival_airport, 
    status, 
    aircraft_code, 
    actual_departure, 
    actual_arrival
from
    {{ ref('stg_airlines__flights') }}

{% if is_incremental() %}

  -- этот фильтр будет применен только при инкрементальном запуске
  where scheduled_departure > (select max(scheduled_departure) from {{ this }})

{% endif %}