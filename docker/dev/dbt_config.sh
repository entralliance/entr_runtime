#!/bin/bash

runuser -l postgres -c $'psql --command \"CREATE USER dbt WITH SUPERUSER PASSWORD \'password123\';\"'
runuser -l postgres -c $'psql --command \"CREATE DATABASE wind_project;\"'

cd wind_project
export USERNAME=dbt
export PASSWORD=password123

dbt run --profiles-dir .