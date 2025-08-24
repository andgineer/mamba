FROM continuumio/miniconda3

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

# miniconda image setup /home/root/.bashrc , but we should repeat that for mamba-user
RUN echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc \
    && echo "source activate ${DOCKER_CONTAINER_CONDA_ENV_NAME}" >> ~/.bashrc

# Accept conda Terms of Service for all channels and update all packages to ensure libarchive from the same channel as mamba
RUN conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main \
    && conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r \
    && conda config --remove channels defaults || true \
    && conda config --add channels conda-forge \
    && conda update --all \
    && /opt/conda/bin/conda install mamba --name base \
    && /opt/conda/bin/conda info --envs \
    && conda list

COPY --chown=mamba-user environment.yml /envs/
ARG PYTHON_VERSION
# Separate layer to optimize builds for different Python versions
RUN CONDA_PYTHON_ARG="python="${PYTHON_VERSION:-$(conda search python | awk 'END {print $2}')} \
    && echo ${CONDA_PYTHON_ARG} \
    && sed -i -e "s/python=?/${CONDA_PYTHON_ARG}/g" /envs/environment.yml \
    && /opt/conda/bin/mamba env create --file /envs/environment.yml \
    && /opt/conda/bin/conda info --envs \
    && export CONDA_DEFAULT_ENV="$(head -1 /envs/environment.yml | cut -d' ' -f2)" \
    && echo export CONDA_DEFAULT_ENV="${CONDA_DEFAULT_ENV}" >> ~/.bashrc \
    && echo export PATH="/opt/conda/envs/${CONDA_DEFAULT_ENV}/bin:${PATH}" >> ~/.bashrc \
    && echo conda activate ${CONDA_DEFAULT_ENV} >> ~/.bashrc

SHELL ["/bin/bash", "-c"]
