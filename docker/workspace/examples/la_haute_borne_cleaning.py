from openoa.utils import filters
import numpy as np

def clean_la_haute_borne(plant):

    plant.scada = plant.scada[(plant.scada["WMET_EnvTmp"] >= -15.0) & (plant.scada["WMET_EnvTmp"] <= 45.0)]

    scada_noindex = plant.scada.reset_index()
    turbine_id_list = list(scada_noindex["asset_id"].unique())
    
    for t_id in turbine_id_list:

        ix_turbine = scada_noindex["asset_id"] == t_id

        # Cancel out readings where the wind vane direction repeats more than 3 times in a row
        ix_flag = filters.unresponsive_flag(scada_noindex[ix_turbine], 3, col=["WMET_HorWdDir"])
        # plant.scada.loc[ix_turbine].loc[ix_flag.values] = np.nan

        # Cancel out the temperature readings where the value repeats more than 20 times in a row
        ix_flag = filters.unresponsive_flag(scada_noindex.loc[ix_turbine], 20, col=["WMET_EnvTmp"])

        # NOTE: ix_flag is flattened here because as a series it's shape = (N, 1) and
        # incompatible with this style of indexing, so we need it as shape = (N,)
        plant.scada.loc[ix_turbine, "WMET_EnvTmp"].loc[ix_flag.values.flatten()] = np.nan
