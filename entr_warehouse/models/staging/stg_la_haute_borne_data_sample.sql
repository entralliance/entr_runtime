select
    CAST(Wind_turbine_name as string) as wind_turbine_name,
    date(Date_time) as date_time, -- spark sql dialect
    CAST(Ba_avg as numeric) as ba_avg,
    CAST(P_avg  as numeric) as p_avg,
    CAST(Ws_avg as numeric) as ws_avg,
    CAST(Va_avg as numeric) as va_avg,
    CAST(Ot_avg as numeric) as ot_avg,
    CAST(Ya_avg as numeric) as ya_avg,
    CAST(Wa_avg as numeric) as wa_avg

from
    {{ref('la_haute_borne_data_sample')}}
