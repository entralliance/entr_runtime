select
    CAST(tag_name as string) as tag_name,
    CAST(tag_is_new as string) as tag_is_new,
    CAST(variable_name as string) as variable_name,
    CAST(variable_long_name as string) as variable_long_name,
    CAST(unit_long_name as string) as unit_long_name,
    CAST(comment as string) as comment

from
    {{ref('la_haute_tag_mapping')}}