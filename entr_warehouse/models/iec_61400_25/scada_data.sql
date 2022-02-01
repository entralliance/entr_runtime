{{ config(materialized='table') }}

with source_data as (

    select '0001-01-01 00:00:00' as utc_datetime,
           '10m' as interval_unit,
           '1' as asset_id,
           'windspeed' as tag_name,
           '10.23' as tag_value

    union all

    select '0001-01-01 00:00:00' as utc_datetime,
           '10m' as interval_unit,
           '1' as asset_id,
           'windspeed' as tag_name,
           '10.23' as tag_value

)

select
    utc_datetime, --timestamp
    interval_unit, -- varchar(100)
    asset_id, -- int
    tag_name, -- int,
    tag_value -- float

from
    source_data
