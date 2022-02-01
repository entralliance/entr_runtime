select
    CAST(entr_tag_id as integer) as entr_tag_id ,
    CAST(entr_tag_name as string) as entr_tag_name,
    CAST(logical_node as string) as logical_node,
    CAST(sensor_name as  string) as sensor_name,
    CAST(presentation_name as  string) as presentation_name,
    CAST(si_unit as  string) as si_unit,
    CAST(value_type as  string) as value_type,
    CAST(data_type as  string) as data_type,
    CAST(collector_type as  string) as collector_type

from
    {{ref('entr_tag_list')}}