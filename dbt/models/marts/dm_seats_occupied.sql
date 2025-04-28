{{
  config(
    materialized = 'table',
    )
}}
select
    fl.flight_id,
    da.airport_code as departure_airport_code,
    da.airport_name as departure_airport_name,
    da.city as departure_airport_city,
    da.coordinates as departure_airport_coordinates,
    aa.airport_code as arrival_airport_code,
    aa.airport_name as arrival_airport_name,
    aa.city as arrival_airport_city,
    aa.coordinates as arrival_airport_coordinates,
    fl.status as flight_status,
    fl.aircraft_code, 
    airc.model as aircraft_model,
    ars.fare_conditions,

    fts.ticket_flights_purchased,
    spf.seats_per_flight - fts.ticket_flights_purchased as ticket_flights_no_sold,
    fts.ticket_flights_amount,
    fts.boarding_passes_issued
from
    {{ ref('fct_flights') }} fl
    inner join {{ ref('dim_airports') }} aa
        on fl.arrival_airport = aa.airport_code
        and fl.actual_arrival between coalesce(aa.dbt_valid_from_custom, '0001-01-01'::date) and coalesce(aa.dbt_valid_to, current_date + 1) 
    inner join {{ ref('dim_airports') }} da 
        on fl.departure_airport = da.airport_code
        and fl.actual_arrival between coalesce(da.dbt_valid_from_custom, '0001-01-01'::date) and coalesce(da.dbt_valid_to, current_date + 1) 
    inner join {{ ref('dim_aircrafts') }} airc
        on fl.aircraft_code = airc.aircraft_code
        and fl.actual_arrival between coalesce(airc.dbt_valid_from_custom, '0001-01-01'::date) and coalesce(airc.dbt_valid_to, current_date + 1) 
    inner join {{ ref('dim_aircraft_seats') }} ars
        on ars.aircraft_code = fl.aircraft_code
        and fl.actual_arrival between coalesce(ars.dbt_valid_from_custom, '0001-01-01'::date) and coalesce(ars.dbt_valid_to, current_date + 1) 
    left join {{ ref('flight_tickets_sold') }} fts
        on fts.flight_id = fl.flight_id
        and fts.scheduled_arrival = fl.scheduled_arrival
        and fts.fare_conditions = ars.fare_conditions
    left join {{ ref('seats_per_flight') }} spf
        on spf.flight_id = fl.flight_id
        and spf.scheduled_arrival = fl.scheduled_arrival
        and spf.fare_conditions = ars.fare_conditions