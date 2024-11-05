# dind-gpu

This repository provides a setup for running Docker-in-Docker (DIND) with GPU support using NVIDIA GPUs. This is particularly useful for scenarios requiring nested Docker containers with GPU access.

## Prerequisites

Ensure that the following requirements are met on the **host machine**:

1. **NVIDIA GPU**: Ensure your system has an NVIDIA GPU.
2. **NVIDIA Drivers**: Installed on the host machine. You can verify this by running:
   ```bash
   nvidia-smi
    ```

## Build the Docker Image

    ```
    docker build -t dind-nvidia .

    ```

## Running the DIND Container

    ```
    docker run -d --privileged --gpus all \
    -p 2375:2375 \
    --name dind-nvidia-container \
    dind-nvidia

    ```

## Accessing the DIND Container
    ```
    docker exec -it dind-nvidia-container bash
    ```

## Running GPU-Enabled Inner Containers
    ```
    docker run --rm --gpus all nvidia/cuda:12.2.0-base-ubuntu22.04 nvidia-smi

    ```