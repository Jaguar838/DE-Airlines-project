{{
  config(
    materialized = 'table',
    )
}}
SELECT
    fl.flight_id as flight_id,
    fl.scheduled_arrival as scheduled_arrival,
    tf.fare_conditions as fare_conditions,
    count(tf.flight_id) as ticket_flights_purchased,
    sum(tf.amount) as ticket_flights_amount,
    count(bs.flight_id) as boarding_passes_issued
FROM
    {{ ref('fct_flights' )}} fl
    inner join {{ ref('fct_ticket_flights') }} tf
        on fl.flight_id = tf.flight_id
    left join {{ ref('fct_boarding_passes') }} bs
        on tf.flight_id = bs.flight_id
        and tf.ticket_no = bs.ticket_no
GROUP BY
    fl.flight_id,
    fl.scheduled_arrival,
    tf.fare_conditions