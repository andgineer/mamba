FROM continuumio/miniconda3

ARG PYTHON_VERSION

# set build-time proxy settings from --build-args if specified
ARG NO_PROXY
ARG HTTP_PROXY
ARG HTTPS_PROXY

# copy build-time proxy-settings into run-time ones
ENV NO_PROXY=$NO_PROXY
ENV HTTP_PROXY=$HTTP_PROXY
ENV HTTPS_PROXY=$HTTPS_PROXY

USER root

RUN useradd -ms /bin/bash mamba-user \
    && chown -R mamba-user /opt/conda

USER mamba-user
COPY --chown=mamba-user environment.yml /envs/

# miniconda image setup /home/root/.bashrc , but we should repeat that for mamba-user
RUN echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc \
    && echo "source activate ${DOCKER_CONTAINER_CONDA_ENV_NAME}" >> ~/.bashrc \
    && /opt/conda/bin/conda install mamba --name base -c conda-forge \
    && /opt/conda/bin/conda info --envs \
    && /opt/conda/bin/mamba env create --file /envs/environment.yml \
    && /opt/conda/bin/conda info --envs \
    && export CONDA_DEFAULT_ENV="$(head -1 /envs/environment.yml | cut -d' ' -f2)" \
    && echo export CONDA_DEFAULT_ENV="${CONDA_DEFAULT_ENV}" >> ~/.bashrc \
    && echo export PATH="/opt/conda/envs/${CONDA_DEFAULT_ENV}/bin:${PATH}" >> ~/.bashrc \
    && echo conda activate ${CONDA_DEFAULT_ENV} >> ~/.bashrc

SHELL ["/bin/bash", "-c"]
