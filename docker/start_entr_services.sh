#!/bin/bash

# Postgres
runuser -l postgres -c '/usr/lib/postgresql/9.3/bin/postgres -D /var/lib/postgresql/9.3/main -c config_file=/etc/postgresql/9.3/main/postgresql.conf' &

# Spark
/usr/local/spark/bin/spark-submit --class org.apache.spark.sql.hive.thriftserver.HiveThriftServer2 &

# Jupyter
/usr/local/bin/start-notebook.sh &

# Release
echo Started ENTR services
