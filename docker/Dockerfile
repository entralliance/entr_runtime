# Start from a core stack version
FROM jupyter/all-spark-notebook:python-3.9.12

## -------------------------------------------------------------------------------
## SECTION: ENTR internal dependency specification

# Warehouse
ARG ENTR_WAREHOUSE_GIT_URL=https://github.com/entralliance/entr_warehouse.git
ARG ENTR_WAREHOUSE_GIT_BRANCH=dev

# OpenOA
ARG OPENOA_GIT_URL=https://github.com/entralliance/OpenOA.git
ARG OPENOA_GIT_BRANCH=dev

## -------------------------------------------------------------------------------
## SECTION: initial setup & package updates
USER root
RUN apt-get update && \
#    apt-get -y upgrade && \

    apt-get install -y libsasl2-modules-gssapi-heimdal libsasl2-dev

## -------------------------------------------------------------------------------
## SECTION: Install and configure Python packages (including DBT)
USER jovyan
RUN pip install pandas matplotlib xgboost numpy xgboost scikit-learn scipy dbt-spark[PyHive]==1.3

## -------------------------------------------------------------------------------
## SECTION: copy local files and grant permissions
USER jovyan
RUN mkdir /home/jovyan/.dbt -p &&\
    mkdir /home/jovyan/src/OpenOA -p &&\
    mkdir /home/jovyan/src/entr_warehouse -p &&\
    mkdir /home/jovyan/warehouse -p

# copy profiles where dbt can find it
COPY build_profiles.yml /home/jovyan/.dbt/profiles.yml

USER root

# grant permissions so that thrift server can create the metastore_db directory
RUN chmod g+w /usr/local/spark

# copy startup wrapper and grant exec permissions
COPY start_hive2.sh /usr/local/bin
RUN chmod +x /usr/local/bin/start_hive2.sh

## -------------------------------------------------------------------------------
## SECTION: Install entr-warehouse
USER jovyan
WORKDIR /home/jovyan/src/entr_warehouse
ENV DBT_PROJECT_PATH=/home/jovyan/src/entr_warehouse
RUN git clone --depth 1 --branch ${ENTR_WAREHOUSE_GIT_BRANCH} ${ENTR_WAREHOUSE_GIT_URL} . && \
    rm -rf .git

# Initialize the warehouse with example data #TODO: Should we have the user do this?
RUN bash /usr/local/bin/start_hive2.sh &&\
    sleep 60 &&\
    dbt debug &&\
    dbt deps &&\
    dbt seed &&\
    dbt run-operation stage_external_sources &&\
    dbt run

## -------------------------------------------------------------------------------
## SECTION: Install and configure OpenOA
# Install and configure OpenOA
USER jovyan
WORKDIR /home/jovyan/src/OpenOA 
RUN git clone --depth 1 --branch ${OPENOA_GIT_BRANCH} ${OPENOA_GIT_URL} . && \
    rm -rf .git &&\
    pip install -e .

# -------------------------------------------------------------------------------
# SECTION: Entry Point
USER jovyan
WORKDIR /home/jovyan
CMD /usr/local/bin/start-notebook.sh
