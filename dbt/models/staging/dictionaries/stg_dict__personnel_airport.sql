{{
  config(
    materialized = 'table'
  )
}}

select distinct
  passenger_name,
  passenger_id
from
  {{ ref('personnel_airport') }}