# Start from a core stack version
FROM jupyter/datascience-notebook

# Install from requirements.txt file
#COPY requirements.txt /tmp/
#RUN conda install --yes --file /tmp/requirements.txt && \
#    fix-permissions $CONDA_DIR && \
#    fix-permissions /home/$NB_USER

RUN git clone https://github.com/NREL/OpenOA.git
RUN pip install ./OpenOA

RUN unzip /home/jovyan/OpenOA/examples/turbine_analysis/data/example_20180829.zip example_20180829/scada_10min_4cols.csv -d /home/jovyan/OpenOA/examples/turbine_analysis/data
RUN cp /home/jovyan/OpenOA/examples/turbine_analysis/data/example_20180829/scada_10min_4cols.csv /home/jovyan/OpenOA/examples/turbine_analysis/data

# ENV PATH /opt/conda/envs/env/bin:$PATH