{{
  config(
    materialized = 'table',
    )
}}
SELECT 
    ticket_no, 
    flight_id, 
    fare_conditions,
    amount
FROM 
    {{ source('staging', 'ticket_flights') }}