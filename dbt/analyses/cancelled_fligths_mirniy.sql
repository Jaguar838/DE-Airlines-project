select
    scheduled_departure::date as scheduled_departure,
    COUNT(*) as cancelled_flight_cnt
from
    {{ ref('fct_fligths') }}
where
    departure_airport= 'MJZ'
    and status = 'Cancelled'
group by
    scheduled_departure::date