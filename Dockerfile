FROM ubuntu:20.04

RUN apt-get update && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    software-properties-common

# Docker.
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
RUN apt-get update && apt-get install -y docker-ce docker-ce-cli containerd.io

# NVIDIA Container Toolkit.
# Add the GPG key.
RUN curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | \
    gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg

# Add the NVIDIA repos.
RUN distribution=$(. /etc/os-release;echo $ID$VERSION_ID); \
    curl -s -L https://nvidia.github.io/libnvidia-container/$distribution/libnvidia-container.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' > /etc/apt/sources.list.d/nvidia-container-toolkit.list

RUN apt-get update && apt-get install -y nvidia-container-toolkit

RUN nvidia-ctk runtime configure --runtime=docker

# Restart Docker to apply changes - optional.
# RUN systemctl restart docker.

# Configure Docker daemon to use the NVIDIA runtime.
RUN mkdir -p /etc/docker
RUN echo '{ "runtimes": { "nvidia": { "path": "nvidia-container-runtime", "runtimeArgs": [] } } }' > /etc/docker/daemon.json

# Expose ports.
EXPOSE 2375 2376

# Start Docker daemon.
CMD ["dockerd", "-H", "unix:///var/run/docker.sock", "-H", "tcp://0.0.0.0:2375"]
