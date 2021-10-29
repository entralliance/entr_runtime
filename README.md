# ENTR

ENTR is a distribution of existing tools, frameworks, and standards, 
packaged together to accelerate the transition to clean energy. 

## Getting Started

1. Install Docker on your local developer machine. Your machine must support bash.
2. Checkout `entr_runtime`, `entr_warehouse`, and `OpenOA` to a working directory on your machine. The directory tree should look like this:
- cwd/
  - entr_runtime
  - entr_warehouse
  - OpenOA
3. From that working directory, run `bash ./entr_runtime/docker/docker_build.sh` to build your ENTR docker image. 'sh dev_build.sh'
4. Run `bash ./entr_runtime/docker/docker_run.sh` to start the container
5. You should be able to log in to Jupyter lab through a browser at `localhost:8888/lab`
6. In a shell from inside the entr-runtime container (you can use a Terminal in Jupyter lab), set up the ENTR warehouse and seed with La Haute Born data.
    - `cd host/entr_warehouse` (Use the host/entr_warehouse so you can better control git versioning from the host machine)
    - If `profiles.yml` is not correct, update it with the example below.
    - `dbt deps --profiles-dir .`
    - `dbt seed --profiles-dir . --no-version-check`
    - `dbt run --profiles-dir . --no-version-check`
7. Use Jupyter Lab to open the OpenOA example notebook at `host/OpenOA/examples/00_toolkit_examples_entr.ipynb`

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
