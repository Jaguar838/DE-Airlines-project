{{
    config(
        materialized = 'view',
    )
}}
SELECT 
    aircraft_code,
    model
FROM 
    {{ ref('stg_airlines__aircraft') }}