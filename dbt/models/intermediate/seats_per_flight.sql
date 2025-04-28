{{
  config(
    materialized = 'table',
    )
}}
SELECT
    fl.flight_id as flight_id,
    fl.scheduled_arrival as scheduled_arrival,
    ars.fare_conditions as fare_conditions,
    count(*) as seats_per_flight
FROM
    {{ ref('fct_flights' )}} fl
    inner join  {{ ref('dim_aircraft_seats') }} ars
        on fl.aircraft_code = ars.aircraft_code
        and fl.actual_arrival between coalesce(ars.dbt_valid_from_custom, '0001-01-01'::date) and coalesce(ars.dbt_valid_to, current_date + 1) 
GROUP BY
    fl.flight_id,
    fl.scheduled_arrival,
    ars.fare_conditions