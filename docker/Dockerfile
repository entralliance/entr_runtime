# Start from a core stack version
FROM jupyter/all-spark-notebook:python-3.10.10

## -------------------------------------------------------------------------------
## SECTION: ENTR internal dependency specification

# Warehouse
ARG ENTR_WAREHOUSE_GIT_URL=https://github.com/entralliance/entr_warehouse.git
ARG ENTR_WAREHOUSE_GIT_BRANCH=v0.0.1

# OpenOA
ARG OPENOA_PIP_REF=git+https://github.com/entralliance/OpenOA.git@7aee792ab8408d2bbb014baea57542fa817e3cb4

# PyEntr
ARG PYENTR_PIP_REF=git+https://github.com/entralliance/py-entr.git@main

## -------------------------------------------------------------------------------
## SECTION: initial setup & package updates
USER root
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get install -y libsasl2-modules-gssapi-heimdal && \
    apt-get install -y libsasl2-dev

## -------------------------------------------------------------------------------
## SECTION: Install and configure Python packages (including DBT)
USER jovyan
RUN conda install -c conda-forge sasl &&\
    pip install pandas matplotlib xgboost numpy sklearn xgboost sklearn scipy dbt-spark[PyHive]==1.3 sasl &&\
    mkdir /home/jovyan/.dbt -p &&\
    mkdir /home/jovyan/src/OpenOA -p &&\
    mkdir /home/jovyan/src/entr_warehouse -p &&\
    mkdir /home/jovyan/warehouse -p

RUN pip install {OPENOA_PIP_REF}
RUN pip install {PYENTR_PIP_REF}

# copy profiles where dbt can find it
COPY build_profiles.yml /home/jovyan/.dbt/profiles.yml


## -------------------------------------------------------------------------------
## SECTION: copy local files and grant permissions
USER root

# grant permissions so that thrift server can create the metastore_db directory
RUN chmod g+w /usr/local/spark

# copy startup wrapper and grant exec permissions
COPY start_hive2.sh /usr/local/bin
RUN chmod +x /usr/local/bin/start_hive2.sh

## -------------------------------------------------------------------------------
## SECTION: Install and configure entr-warehouse
USER jovyan
WORKDIR /home/jovyan/src/entr_warehouse
ENV DBT_PROJECT_PATH=/home/jovyan/src/entr_warehouse
RUN git clone --depth 1 --branch ${ENTR_WAREHOUSE_GIT_BRANCH} ${ENTR_WAREHOUSE_GIT_URL} . && \
    rm -rf .git
RUN bash /usr/local/bin/start_hive2.sh &&\
    sleep 60 &&\
    dbt debug &&\
    dbt deps &&\
    dbt seed &&\
    dbt run-operation stage_external_sources &&\
    dbt run

# -------------------------------------------------------------------------------
# SECTION: Entry Point
USER jovyan
WORKDIR /home/jovyan
CMD /usr/local/bin/start-notebook.sh
