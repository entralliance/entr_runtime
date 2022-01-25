# Start from a core stack version
FROM jupyter/all-spark-notebook

# -------------------------------------------------------------------------------
# SECTION: Install and configure the Postgres database
# pattern: https://severalnines.com/database-blog/deploying-postgresql-docker-container

USER root

# Install requirement: https://stackoverflow.com/questions/50757647/e-gnupg-gnupg2-and-gnupg1-do-not-seem-to-be-installed-but-one-of-them-is-requ
RUN apt-get upgrade
RUN apt-get update
RUN apt-get install -y gnupg2

# Add the PostgreSQL PGP key to verify their Debian packages.
# It should be the same key as https://www.postgresql.org/media/keys/ACCC4CF8.asc
RUN sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 7FCC7D46ACCC4CF8

# Add PostgreSQL's repository. It contains the most recent stable release
#     of PostgreSQL, ``9.3``.
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ focal-pgdg main" > /etc/apt/sources.list.d/pgdg.list

# Install ``python-software-properties``, ``software-properties-common`` and PostgreSQL 9.3
#  There are some warnings (in red) that show up during the build. You can hide
#  them by prefixing each apt-get statement with DEBIAN_FRONTEND=noninteractive
RUN apt-get install -y postgresql-12 postgresql-client-12 postgresql-contrib-12 # removed: python-software-properties software-properties-common

# Note: The official Debian and Ubuntu images automatically ``apt-get clean``
# after each ``apt-get``

# Run the rest of the commands as the ``postgres`` user created by the ``postgres-9.3`` package when it was ``apt-get installed``
USER postgres

# Create a PostgreSQL role named ``postgresondocker`` with ``postgresondocker`` as the password and
# then create a database `postgresondocker` owned by the ``postgresondocker`` role.
# Note: here we use ``&&\`` to run commands one after the other - the ``\``
#       allows the RUN command to span multiple lines.
RUN    /etc/init.d/postgresql start &&\
    psql --command "CREATE USER postgresondocker WITH SUPERUSER PASSWORD 'postgresondocker';" &&\
    createdb -O postgresondocker postgresondocker

# Adjust PostgreSQL configuration so that remote connections to the
# database are possible.
RUN echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/12/main/pg_hba.conf

# And add ``listen_addresses`` to ``/etc/postgresql/9.3/main/postgresql.conf``
RUN echo "listen_addresses='*'" >> /etc/postgresql/12/main/postgresql.conf

# Expose the PostgreSQL port
# EXPOSE 5432

# Add VOLUMEs to allow backup of config, logs and databases
VOLUME  ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]

# Set the default command to run when starting the container
# pattern: https://docs.docker.com/config/containers/multi-service_container/
USER root
COPY startup_wrapper_script.sh /usr/local/bin
RUN ["chmod", "+x", "/usr/local/bin/startup_wrapper_script.sh"]
CMD /usr/local/bin/startup_wrapper_script.sh

# copy the postgres driver in (COMMENT IN THE FOLLOWING AFTER DOWNLOADING POSTGRES DRIVER JAR)
# COPY postgresql-42.2.19.jar /home/jovyan/

## -------------------------------------------------------------------------------
## SECTION: Install and configure DBT
## source: https://meltano.com/

# source: https://github.com/mikekaminsky/dbt-setup-example
RUN pip install pandas
RUN pip install matplotlib
RUN pip install xgboost
RUN pip install numpy
RUN pip install sklearn
RUN pip install xgboost
RUN pip install sklearn
RUN pip install scipy

USER root
RUN apt-get install -y libsasl2-modules-gssapi-heimdal
RUN apt-get install libsasl2-dev
RUN conda install -c conda-forge sasl
RUN pip install dbt==0.21.1
RUN pip install dbt-spark[PyHive]==0.21.1
RUN pip install sasl

# COPY run_data_pipeline.sh /home/jovyan/
#RUN echo "conda activate $(head -1 ${environment} | cut -d' ' -f2)" >> ~/.bashrc

###############################################
## SECTION: Configure Thrift server
USER root
# needed so that thrift server can create the megastore_db directory
RUN chmod g+w /usr/local/spark

# -------------------------------------------------------------------------------
# SECTION: Seed Entr Warehouse by Running DBT Pipeline
ADD . /opt/entr

# -------------------------------------------------------------------------------
# SECTION: Seed Entr Warehouse by Running DBT Pipeline
WORKDIR /opt/entr/entr_warehouse/

RUN dbt deps --profiles-dir .
RUN dbt seed --profiles-dir . --no-version-check
RUN dbt run --profiles-dir . --no-version-check


# -------------------------------------------------------------------------------
# SECTION: Install and configure OpenOA

USER root
RUN pip install -e /opt/entr/OpenOA

# -------------------------------------------------------------------------------
# SECTION: Entry Point

USER root
WORKDIR /home/jovyan