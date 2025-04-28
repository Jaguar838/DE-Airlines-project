{{
    config(
        materialized='view'
    )
}}

select
  book_ref,
  book_date,
  total_amount

from {{ ref('stg_airlines__bookings') }}
