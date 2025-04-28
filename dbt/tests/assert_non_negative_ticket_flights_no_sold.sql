SELECT
    so.flight_id,
    so.ticket_flights_no_sold
FROM
    {{ ref('dm_seats_occupied') }} so
WHERE
    so.ticket_flights_no_sold < 0