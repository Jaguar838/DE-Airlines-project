{% set current_date = run_started_at | string | truncate(10,True,"") %}
{%set current_year = run_started_at | string | truncate(4,True,"") | int %}
{%set last_year = current_year - 10 %}

select 
    count(*) as {{adapter.quote('cnt')}}
from 
    {{ ref('stg_airlines__flights') }}
where 
    scheduled_departure between '{{ current_date }}' and '{{ current_date | replace('YYYY', last_year) }}'


{#- set source_relation = adapter.get_relation(
    database='dwh_flight',
    schema='staging', 
    identifier='bookings') -#}    


{% set source_relation = api.Relation.create(
    database='dwh_flight',
    schema='staging',
    identifier='bookings') %}

    {{ source_relation.database }}
    {{ source_relation.schema }}
    {{ source_relation.identifier }}
    {{ source_relation.is_table }}
    {{ source_relation.is_view }}
    {{ source_relation.is_cte }}

{% set columns = adapter.get_columns_in_relation(source_relation) %}
{% for column in columns -%}
   {{'Columns: ' ~ column }}
{% endfor %}

{% do adapter.create_schema(
    api.Relation.create(
        database='dwh_flight',
        schema='test_schema'
    )
) %}

{% do adapter.drop_schema(
    api.Relation.create(
        database='dwh_flight',
        schema='test_schema'
    )
) %}

{% set fct_fligths = api.Relation.create(
    database='dwh_flight',
    schema='intermediate',
    identifier='fct_fligths',
    type='table'
) %}

{% set stg_airlines__flights = api.Relation.create(
    database='dwh_flight',
    schema='intermediate',
    identifier='stg_airlines__flights',
    type='table'
) %}

{% for column in adapter.get_missing_columns(stg_airlines__flights, fct_fligths) %}
{{'Columns: ' ~ column }}
{%- endfor %}


{#{ do adapter.expand_target_column_types(
    stg_airlines__flights,
    fct_fligths
) }

{% for column in adapter.get_columns_in_relation(stg_airlines__flights) %}
{{'Columns: ' ~ column }}
{%- endfor %}

{% for column in adapter.get_columns_in_relation(fct_flights) %}
{{'Columns: ' ~ column }}
{%- endfor %} #}