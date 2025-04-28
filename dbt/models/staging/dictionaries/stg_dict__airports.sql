{{
  config(
    materialized = 'table',
    )
}}
SELECT 
    airport_code, 
    airport_name, 
    city, 
    coordinates, 
    timezone
FROM 
    {{ ref('airports') }}