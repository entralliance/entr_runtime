# ENTR

ENTR is a distribution of existing tools, frameworks, and standards, 
packaged together to accelerate the transition to clean energy.

The ENTR runtime provides a containerized environment with a Spark server, a version 
of Python compatible with OpenOA, a Jupyter notebook server and dbt. This runtime can
be used for development and learning in place of the stack components used in
production by renewable generator operators.

## Getting Started

<!-- some steps copied over from https://github.com/airbytehq/airbyte/blob/master/docs/deploying-airbyte/local-deployment.md -->
1. Install Docker on your workstation \(see [instructions](https://www.docker.com/products/docker-desktop)\). Make sure you're on the latest version of `docker-compose`.
    - We recommend following [this guide](https://docs.docker.com/docker-for-windows/install/) to install Docker on Windows. After installing the WSL 2 backend and Docker you should be able to run containers using Windows PowerShell.
2. In a bash shell (using WSL if on Windows), clone `entr_runtime` to a working directory on your machine (`git clone git@github.com:entralliance/entr_runtime.git`)
3. Enter the newly created directory (`cd entr_runtime`) and run `docker compose up`, which will build the Docker image if it doesn't already exist and run it.
4. Click on the link to Jupyter server printed to stdout when the container starts running (127.0.0.1:8888/lab?token=<randomly_generated_token>)
5. Open a terminal from Jupyter (File > New > Terminal) and navigate to the location where your dbt project is installed (see section "Assumed Repository Structure" section below) using `cd ~/host/entr_warehouse` and run `dbt debug` to test your connection to the Spark warehouse.
6. Once the connection to the warehouse is confirmed, install the dbt packages for your project using `dbt deps`
7. Seed the example data contained in the entr_warehouse repo using `dbt seed` to instantiate them in the Spark warehouse
6. Run `dbt run` to build all models in the Spark warehouse, which can now be consumed by any application connected to the Spark warehouse such as OpenOA

### Assumed Repository Structure
When the entr_runtime Docker image is built locally, it will try to mount [OpenOA](https://github.com/entralliance/OpenOA) and [entr_warehouse](https://github.com/entralliance/entr_warehouse) directories that exist at the same directory level where entr_runtime is installed. These two repositories are meant to be the locations where analytical development work and dbt data modeling development work persist locally, and those directories will be created if they don't already exist. Users can change the parameters in the `.env` file to map the mounts to different locations if OpenOA or entr_runtime exist in a different location on the local filesystem.

### Building runtime container
```
docker build -t entr/entr-runtime docker
```

### Running the entr runtime container

Basic mode, forwarding all ports to localhost:

```
docker run -p 8888:8888 -p 8080:8080 -p 4040:4040 entr/entr-runtime
# use the option --no-cache to force rebuilding of each layer
```

Dev mode, overload OpenOA and entr_warehouse with development versions

```
docker run -p 8888:8888 -p 8080:8080 -p 4040:4040 -v <path-to-local-clone-of-OpenOA>:/home/jovyan/src/OpenOA -v <path-to-local-clone-of-entr_warehouse>:/home/jovyan/src/entr_warehouse entr/entr-runtime-dev
```
Note, you will then need to re-install OpenOA in editable mode, or run `dbt run` as needed to update the container with the new code.

```
!connect jdbc:hive2://localhost:10000
```

## Roadmap

Coming soon!
