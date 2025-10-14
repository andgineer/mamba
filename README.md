[![Docker Automated build](https://img.shields.io/docker/image-size/andgineer/mamba)](https://hub.docker.com/r/andgineer/mamba)

# Accelerated Conda dependency resolver in a secure Docker container

A lightweight [Docker image](https://hub.docker.com/r/andgineer/mamba) that pairs the Conda ecosystem with [Mamba](https://github.com/mamba-org/mamba) for fast, reproducible scientific Python environments.

## Features
- Optimized dependency resolution via Mamba with lightning-fast C++ core.
- Ships with a non-root user for safer production deployments.
- Provides Python 3.12 and 3.13 variants with consistent tooling (numpy, pandas, scikit-learn, boto3, requests, pyarrow, pyyaml).

## Quick Start
```bash
docker run --rm -it andgineer/mamba python --version
```
Check the default toolchain:
```bash
docker run --rm -it andgineer/mamba bash -lc "mamba --version && conda list"
```

## Tags
- `latest`: Matches the default Python release tracked by CI (currently 3.13).
- `3.x`: Pin a specific Python minor (for example `3.12`, `3.13`).
- `mamba-<version>` / `mamba-<version>-py<python>`: Сombinations of Mamba and Python versions (e.g., `mamba-1.4.3-py3.12`).

## Security Notes
The image creates and runs as `mamba-user`, avoiding root by default. Extend the image using the same user or explicit `USER` instructions to preserve that model.

## Additional Resources
- Docker Hub: https://hub.docker.com/r/andgineer/mamba
