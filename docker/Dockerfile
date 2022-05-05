# Start from a core stack version
FROM jupyter/all-spark-notebook

# -------------------------------------------------------------------------------
# SECTION: initial setup & package updates
USER root
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get install -y libsasl2-modules-gssapi-heimdal && \
    apt-get install -y libsasl2-dev

## -------------------------------------------------------------------------------
## SECTION: Install and configure Python packages (including DBT)
USER jovyan
RUN conda install -c conda-forge sasl &&\
    pip install pandas matplotlib xgboost numpy sklearn xgboost sklearn scipy dbt-spark[PyHive]==1.0.0 sasl &&\
    mkdir /home/jovyan/.dbt -p &&\
    mkdir /home/jovyan/src/OpenOA -p &&\
    mkdir /home/jovyan/src/entr_warehouse -p &&\
    mkdir /home/jovyan/warehouse -p

# copy profiles where dbt can find it
COPY build_profiles.yml /home/jovyan/.dbt/profiles.yml

# Install and configure OpenOA
WORKDIR /home/jovyan/src/OpenOA
RUN git clone --depth 1 https://github.com/entralliance/OpenOA.git . && \
    rm -rf .git &&\
    pip install .

## -------------------------------------------------------------------------------
## SECTION: copy local files and grant permissions
USER root

# grant permissions so that thrift server can create the metastore_db directory
RUN chmod g+w /usr/local/spark

# copy startup wrapper and grant exec permissions
COPY startup_wrapper_script.sh /usr/local/bin
COPY start_entr_services.sh /usr/local/bin
RUN chmod +x /usr/local/bin/startup_wrapper_script.sh &&\
    chmod +x /usr/local/bin/start_entr_services.sh

## -------------------------------------------------------------------------------
## SECTION: Install and configure entr-warehouse
USER jovyan
WORKDIR /home/jovyan/src/entr_warehouse
RUN git clone --depth 1 https://github.com/entralliance/entr_warehouse.git . && \
    rm -rf .git &&\
    bash /usr/local/bin/start_entr_services.sh &&\
    sleep 60 &&\
    dbt debug &&\
    dbt deps &&\
    dbt seed &&\
    dbt run

# -------------------------------------------------------------------------------
# SECTION: Entry Point
USER jovyan
WORKDIR /home/jovyan
CMD /usr/local/bin/startup_wrapper_script.sh

