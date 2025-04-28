{{
  config(
    materialized = 'table',
    )
}}
SELECT 
    aircraft_code, 
    model,
    range
FROM 
    {{ ref('aircrafts') }}