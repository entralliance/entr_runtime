# Script builds the warehouse. When the script finishes, check Google BigQuery.

dbt deps --profiles-dir .
dbt seed --profiles-dir . --no-version-check
dbt run --profiles-dir .  --no-version-check
