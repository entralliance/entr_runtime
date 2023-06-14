# ENTR Runtime Docker Container

> **Note**
> For the latest documentation please see our docs website at [entralliance.github.io](https://entralliance.github.io/getting_started.html#installating-the-entr-runtime).

ENTR is a distribution of existing tools, frameworks, and standards, 
packaged together to accelerate the transition to clean energy.

The ENTR runtime provides a containerized environment with a Spark server, a version 
of Python compatible with OpenOA, a python package to facilitate using the entr warehouse, a Jupyter notebook server and dbt.
This runtime can be used for development and learning in place of the stack components used in production by renewable generator operators.

## Quickstart

1. Install Docker Desktop on your workstation \(see [instructions](https://www.docker.com/products/docker-desktop)\).
    - We recommend following [this guide](https://docs.docker.com/docker-for-windows/install/) to install Docker on Windows. After installing the WSL 2 backend and Docker you should be able to run containers using Windows PowerShell.

2. Pull and run our image from github container registry:

```docker pull ghcr.io/entralliance/entr_runtime:latest```

> **Warning**
> There are numerous security considerations when pulling and running images from the public internet. This open-source image is meant for development and learning, and we make no guarantees around security patching nor the presence of vulnerabilities in this image. Users should take the necessary steps to ensure operational security.

3. Run the entr runtime container, forwarding the necessary ports:

```docker run -p 8888:8888 ghcr.io/entralliance/entr_runtime:latest```

4. Open the Jupyter link printed to the terminal in your web browser.

From here, you can try many different things:

### Running an example notebook in OpenOA
1. Use the file navigator on the left side of the browser window to navigate to `/examples`

2. Open any of the notebooks and run the cells.


### Using Beeline and Hive2
If you want to interact with the warehouse using beeline, click on the "Terminal" button in Jupyter Hub, then type:
```
start_hive2.sh
```
Then, you can open a beeline prompt. Note, there is no username and password
```
beeline -u jdbc:hive2://localhost:10000
> use entr_warehouse;
> show tables;
```

## Developing ENTR Runtime Components

The ENTR runtime contains the following preinstalled components: OpenOA, entr_warehouse, and py-entr. To develop these components, you check out development versions of these packages to your local filesystem, and then start the entr image with these paths mounted as volumes. You then install the packages from these volumes in editable mode. This allows you to edit the code in these components on your local machine, and see the changes immediately reflected in the runtime. If `$ENTR_HOME` is the directory you'd like to work from:

1. `cd $ENTR_HOME`
2. `git clone https://github.com/entralliance/entr_warehouse.git`
3. `git clone https://github.com/entralliance/OpenOA.git`
4. `git clone https://github.com/entralliance/py_entr.git`
4. `git clone https://github.com/entralliance/entr_runtime.git`
5. Optionally, build the entr image. You can also use the dev image from the container registry as discussed in the quickstart guide.
6. Now, start the entr container in dev mode, mapping the directories you checked out to paths within the container:
`docker run -p 8888:8888 -v $ENTR_HOME/OpenOA:/home/jovyan/src/OpenOA -v $ENTR_HOME/entr_warehouse:/home/jovyan/src/entr_warehouse -v $ENTR_HOME/py-entr:/home/jovyan/src/py-entr`.
7. Once inside the container, you will then need to re-install OpenOA and/or pyentr editable mode, or run `dbt run` as needed to materialize any changes to the dbt model code in the warehouse.
    - To install OpenOA in editable mode:
        - `cd /home/jovyan/src/OpenOA`
        - `pip install -e .`
    - To install Py-Entr in editable mode:
        - `cd /home/jovyan/src/py-entr`
        - `pip install -e .`

### To Update the Warehouse

Changes to the warehouse may require re-running dbt. To do this:

1. Open a terminal from Jupyter (File > New > Terminal) and navigate to the location where your dbt project is installed (see section "Assumed Repository Structure" section below) using `cd ~/src/entr_warehouse` and run `dbt debug` to test your connection to the Spark warehouse.
2. Once the connection to the warehouse is confirmed, install the dbt packages for your project using `dbt deps`
3. Seed the metadata tables contained in the entr_warehouse repo using `dbt seed` to instantiate them in the Spark warehouse
4. (Re-)register example or newly added source data files with `dbt run-operation stage_external_sources`
5. Run `dbt run` to build all models in the Spark warehouse, which can now be consumed by any application connected to the Spark warehouse such as OpenOA

## Building the entr_runtime image

In most cases, we reccomend using the pre-built entr_runtime image avaialble from the github container registry. If you need to rebuild the image yourself, follow the instructions below:

1. Install Git and Docker Desktop on your workstation.

2. Clone the ENTR Runtime repository:

```
git clone git@github.com:entralliance/entr_runtime.git
git checkout dev
```

3. Navigate to the `entr_runtime` directory and run the following, replacing `yourname` with your username:

```
docker build -t yourname/entr-runtime docker
```

> **Note**
> Use the option ``--no-cache`` to force rebuilding of each layer*

4. Run the image you just built:

```docker run -p 8888:8888 yourname/entr_runtime```


