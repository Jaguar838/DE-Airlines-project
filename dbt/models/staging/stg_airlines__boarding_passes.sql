{{
  config(
    materialized = 'table',
    )
}}
SELECT 
    ticket_no, 
    flight_id, 
    boarding_no, 
    seat_no
FROM 
    {{ source('staging', 'boarding_passes') }}