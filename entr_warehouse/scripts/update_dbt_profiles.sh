#! /bin/bash

# make .dbt directory if it doesn't already exist
mkdir ~/.dbt -p

# copy profiles.yml to ~/.dbt - DEPENDS ON entr_warehouse MOUNT LOCATION
cp ~/host/entr_warehouse/profiles.yml ~/.dbt/profiles.yml -i

# force Linux line endings in the file
sed -i.bak 's/\r$//' ~/.dbt/profiles.yml
