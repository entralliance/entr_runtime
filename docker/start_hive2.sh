#!/bin/bash

# # Postgres
# runuser -l postgres -c '/usr/lib/postgresql/9.3/bin/postgres -D /var/lib/postgresql/9.3/main -c config_file=/etc/postgresql/9.3/main/postgresql.conf' &

# Spark
/usr/local/spark/bin/spark-submit\
    --conf spark.hive.server2.thrift.bind.host=localhost\
    --conf spark.sql.warehouse.dir=/home/jovyan/warehouse\
    --conf spark.hadoop.javax.jdo.option.ConnectionURL=jdbc:derby:\;databaseName=/home/jovyan/warehouse/metastore_db\;create=true\
    --class org.apache.spark.sql.hive.thriftserver.HiveThriftServer2 &

# Release
echo Started HIVE2 Service
