with
     la_haute as (select * from {{ref('stg_la_haute_borne_data_sample')}}),
     map as (select * from {{ref('stg_la_haute_tag_mapping')}}),
     std_tags as (select * from {{ref('stg_entr_tag_list')}}),

la_haute_molten as (
    {{dbt_utils.unpivot(ref('stg_la_haute_borne_data_sample'),
    cast_to='numeric',
    exclude=['wind_turbine_name','date_time'],
    field_name='scada_tag_name',
    value_name='tag_value')}}
),

tag_join as (
    select
        map.tag_name as entr_tag_name,
        la_haute_molten.*
    from la_haute_molten
    left join map on split(lower(la_haute_molten.scada_tag_name),"_")[0] = lower(map.variable_name)
)

select * from tag_join