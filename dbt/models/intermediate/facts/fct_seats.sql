{{
    config(
        materialized = 'view',
    )
}}
SELECT 
    aircraft_code,
    seat_no,
    fare_conditions
FROM 
    {{ ref('stg_airlines__seats') }}