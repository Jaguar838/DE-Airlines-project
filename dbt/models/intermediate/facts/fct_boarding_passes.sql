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
    {{ ref('stg_airlines__boarding_passes') }}