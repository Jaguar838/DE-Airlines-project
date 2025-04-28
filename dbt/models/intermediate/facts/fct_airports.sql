{{
    config(
        materialized = 'view',
    )
}}
SELECT 
    airport_code,
    airport_name,
    city
FROM 
    {{ ref('stg_airlines__airports') }}