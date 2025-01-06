[![Docker Automated build](https://img.shields.io/docker/image-size/andgineer/mamba)](https://hub.docker.com/r/andgineer/mamba)

## Fast Scientific Anaconda/Mamba Docker Container
This [Docker image](https://hub.docker.com/r/andgineer/mamba) provides a lightweight scientific Python environment 
based on [Mamba](https://github.com/mamba-org/mamba), 
a fast, robust C++ reimplementation of the Conda package manager.

### Features

- Built on Mamba for significantly faster package management compared to Conda
- Non-root user setup for enhanced security in production environments
- Compatible with the Anaconda package ecosystem
- Optimized for scientific computing with Python

### Usage

    docker run --rm -it andgineer/mamba python --version

### Available Tags

- latest: Latest stable Anaconda Python version compatible with Pandas
- 3.x: Specific Python version tags (e.g., 3.9, 3.10)

### Security
The container runs as a non-root user by default, making it suitable for production environments and 
following security best practices.
