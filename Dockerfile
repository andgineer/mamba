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

# Accept ToS by creating the necessary file manually and configure channels
RUN mkdir -p ~/.conda \
    && echo "channels:" > ~/.conda/.condarc \
    && echo "  - conda-forge" >> ~/.conda/.condarc \
    && echo "channel_priority: strict" >> ~/.conda/.condarc \
    && conda config --system --set auto_update_conda false \
    && conda config --system --remove channels defaults || true \
    && conda config --system --add channels conda-forge \
    && conda config --system --set channel_priority strict \
    && echo "yes" | conda update --all \
    && echo "yes" | conda install mamba --name base \
    && /opt/conda/bin/conda info --envs \
    && conda list

COPY --chown=mamba-user environment.yml /envs/
ARG PYTHON_VERSION
# Separate layer to optimize builds for different Python versions
RUN CONDA_PYTHON_ARG="python="${PYTHON_VERSION:-$(conda search python | grep -E "python\s+3\.(1[0-3])\.[0-9]+\s" | grep -v rc | grep -v alpha | grep -v beta | tail -1 | awk '{print $2}')} \
    && echo ${CONDA_PYTHON_ARG} \
    && sed -i -e "s/python=?/${CONDA_PYTHON_ARG}/g" /envs/environment.yml \
    && /opt/conda/bin/mamba env create --file /envs/environment.yml \
    && /opt/conda/bin/conda info --envs \
    && export CONDA_DEFAULT_ENV="$(head -1 /envs/environment.yml | cut -d' ' -f2)" \
    && echo export CONDA_DEFAULT_ENV="${CONDA_DEFAULT_ENV}" >> ~/.bashrc \
    && echo export PATH="/opt/conda/envs/${CONDA_DEFAULT_ENV}/bin:${PATH}" >> ~/.bashrc \
    && echo conda activate ${CONDA_DEFAULT_ENV} >> ~/.bashrc

SHELL ["/bin/bash", "-c"]
