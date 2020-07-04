# Start from a core stack version
FROM jupyter/datascience-notebook

# -------------------------------------------------------------------------------
# SECTION: Install and configure OpenOA

# clone OpenOA
RUN git clone https://github.com/NREL/OpenOA.git
RUN pip install ./OpenOA

# extract sample OpenOA data
RUN unzip /home/jovyan/OpenOA/examples/turbine_analysis/data/example_20180829.zip example_20180829/scada_10min_4cols.csv -d /home/jovyan/OpenOA/examples/turbine_analysis/data
RUN cp /home/jovyan/OpenOA/examples/turbine_analysis/data/example_20180829/scada_10min_4cols.csv /home/jovyan/OpenOA/examples/turbine_analysis/data


# -------------------------------------------------------------------------------
# SECTION: Install and configure the Postgres database
# pattern: https://severalnines.com/database-blog/deploying-postgresql-docker-container

USER root

# Install requirement: https://stackoverflow.com/questions/50757647/e-gnupg-gnupg2-and-gnupg1-do-not-seem-to-be-installed-but-one-of-them-is-requ
RUN apt-get update && apt-get install -y gnupg2

# Add the PostgreSQL PGP key to verify their Debian packages.
# It should be the same key as https://www.postgresql.org/media/keys/ACCC4CF8.asc
RUN sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 7FCC7D46ACCC4CF8

# Add PostgreSQL's repository. It contains the most recent stable release
#     of PostgreSQL, ``9.3``.
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main" > /etc/apt/sources.list.d/pgdg.list

# Install ``python-software-properties``, ``software-properties-common`` and PostgreSQL 9.3
#  There are some warnings (in red) that show up during the build. You can hide
#  them by prefixing each apt-get statement with DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get install -y postgresql-9.3 postgresql-client-9.3 postgresql-contrib-9.3 # removed: python-software-properties software-properties-common

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
RUN echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/9.3/main/pg_hba.conf

# And add ``listen_addresses`` to ``/etc/postgresql/9.3/main/postgresql.conf``
RUN echo "listen_addresses='*'" >> /etc/postgresql/9.3/main/postgresql.conf

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


# Configure container startup
#ENTRYPOINT ["tini", "-g", "--"]
## CMD ["start-notebook.sh"]
#CMD ["start-notebook.sh", "runuser -l postgres -c '/usr/lib/postgresql/9.3/bin/postgres -D /var/lib/postgresql/9.3/main -c config_file=/etc/postgresql/9.3/main/postgresql.conf'"]

USER root