{{
  config(
    materialized='view'
  )
  }}

select
  ticket_no,
  book_ref,
  passenger_id,
  passenger_name,
  contact_data

from {{ ref('stg_airlines__tickets') }}