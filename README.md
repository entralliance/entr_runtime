# ENTR

ENTR is a distribution of existing tools, frameworks, and standards, 
packaged together to accelerate the transition to clean energy. 

## Getting Started

1. Install Docker on your local developer machine. Your machine must support bash.
2. Run ./docker/docker_build.sh to build your ENTR docker image. 'sh dev_build.sh'
3. Run ./docker/docker_run.sh to run your ENTR docker image and log into Jupyter.
4. In a shell from inside the ENTR runtime, set up the ENTR warehouse and seed with La Haute Born data
    - `cd entr_warehouse`
    - If `profiles.yml` is not correct, update it with the example below.
    - `dbt deps --profiles-dir .`
    - `dbt seed --profiles-dir . --no-version-check`
    - `dbt run --profiles-dir . --no-version-check`


Example of profiles.yml
```
entr_warehouse:   

  target: dev   

  outputs:     

    dev:       

      type: spark

      method: thrift       

      schema: entr_warehouse       

      host: 127.0.0.1       

      port: 10000
```



## Roadmap

Coming soon!
