# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Docker project that provides a fast scientific Python environment based on Mamba, a C++ reimplementation of the Conda package manager. The container is optimized for scientific computing and runs with a non-root user for enhanced security.

## Architecture

- **Base Image**: Uses `continuumio/miniconda3` as the foundation
- **User Setup**: Creates a non-root `mamba-user` for security
- **Package Management**: Uses Mamba instead of Conda for faster package operations
- **Environment**: Configured through `environment.yml` with scientific Python packages (numpy, pandas, scikit-learn, etc.)
- **Build Process**: Supports parameterized Python versions via build args

## Key Files

- `Dockerfile`: Multi-stage container build with Mamba installation and environment setup
- `environment.yml`: Conda environment specification with scientific Python dependencies
- `.github/workflows/dockerhub.yml`: CI/CD pipeline for building and pushing Docker images

## Development Commands

### Building the Docker Image
```bash
# Build with default Python version
docker build -t mamba .

# Build with specific Python version
docker build --build-arg PYTHON_VERSION=3.12 -t mamba:3.12 .
```

### Running the Container
```bash
# Interactive shell
docker run --rm -it mamba bash

# Run Python directly
docker run --rm -it mamba python --version
```

### CI/CD
The project uses GitHub Actions to automatically build and push images for Python 3.12 and 3.13 to Docker Hub when changes are pushed to the master branch.

## Environment Configuration

The conda environment is defined in `environment.yml` and includes:
- Core scientific libraries (numpy, pandas, scikit-learn)
- AWS integration (boto3)
- Data processing (pyarrow, pyyaml)
- HTTP requests library

## Docker Image Tags

- `latest`: Python 3.13 (current default)
- `3.12`, `3.13`: Specific Python versions
- Images are built for both linux/amd64 and linux/arm64 platforms