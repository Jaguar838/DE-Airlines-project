{{
  config(
    materialized = 'incremental',
    unique_key='flight_id',
    incremental_strategy='delete+insert',
    )
}} 
{% set incremental_days = 3000 %} 
SELECT 
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
FROM 
    {{ source('staging', 'flights') }}

{% if is_incremental() %}

WHERE
    scheduled_departure >= current_date - {{ incremental_days }}
    OR scheduled_arrival >= current_date - {{ incremental_days }}
    OR actual_departure >= current_date - {{ incremental_days }}
    OR actual_arrival >= current_date - {{ incremental_days }}

{% endif %}