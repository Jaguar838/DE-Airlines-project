{{
  config(
    materialized = 'table',
    )
}}
SELECT 
    aircraft_code, 
    seat_no, 
    fare_conditions
FROM 
    {{ ref('seats') }}