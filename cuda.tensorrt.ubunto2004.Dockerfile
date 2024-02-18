FROM nvidia/cuda:12.0.1-cudnn8-devel-ubuntu20.04

LABEL maintainer="tannousgeagea@hotmail.com"
LABEL version="1.1b1"


ARG OS="ubuntu2004"
ARG TAG="8.6.1-cuda-12.0"
ARG TENSORRT_VERSION="8.6.1.6-1+cuda12.0"
# add tensorrt version
ARG TENSORRT=nv-tensorrt-local-repo-ubuntu2004-8.6.1-cuda-11.8_1.0-1_amd64.deb
ARG TENSORRT_REPO=https://developer.nvidia.com/downloads/compute/machine-learning/tensorrt/secure/8.6.1/local_repos

# add tensorrt key
ARG TENSORTRT_KEY=nv-tensorrt-local-repo-ubuntu2004-8.6.1-cuda-11.8-keyring.gpg

ENV DEBIAN_FRONTEND=noninteractive

# install necessary packages
RUN apt-get update && DEBIAN_FRONTEND=noninteracttive apt-get install -q -y --no-install-recommends \
    apt-utils \
    vim \
    git \
    iputils-ping \
    net-tools \
    netcat \
    ssh \
    curl \
    lsb-release \
    wget \
    zip \
    sudo \
    && rm -rf /var/lib/apt/lists/*

COPY nv-tensorrt-local-repo-${OS}-${TAG}_1.0-1_amd64.deb /tmp/
RUN /bin/bash -c "sudo dpkg -i /tmp/nv-tensorrt-local-repo-${OS}-${TAG}_1.0-1_amd64.deb"
RUN /bin/bash -c "sudo cp /var/nv-tensorrt-local-repo-${OS}-${TAG}/*-keyring.gpg /usr/share/keyrings/"

RUN apt-get update && DEBIAN_FRONTEND=noninteracttive apt-get install -q -y --no-install-recommends \
    tensorrt=${TENSORRT_VERSION} \
    libnvinfer8=${TENSORRT_VERSION} \
    libnvinfer-plugin8=${TENSORRT_VERSION} \
    libnvinfer-dev=${TENSORRT_VERSION} \
    libnvinfer-plugin-dev=${TENSORRT_VERSION} \
    libnvonnxparsers8=${TENSORRT_VERSION} \
    libnvonnxparsers-dev=${TENSORRT_VERSION} \
    libnvparsers8=${TENSORRT_VERSION}  \
    libnvparsers-dev=${TENSORRT_VERSION} \
    && rm -rf /var/lib/apt/lists/*


# install python dependencies
RUN apt-get update && DEBIAN_FRONTEND=noninteracttive apt-get install -q -y --no-install-recommends \
    python3 \
    python3-pip \
    python3-wstool \
    python3-distutils \
    python3-psutil \
    python3-tk \
    build-essential \
    git \
    && rm -rf /var/lib/apt/lists/*

# Setup user account
ARG uid=1000
ARG gid=1000
RUN groupadd -r -f -g ${gid} appuser && useradd -o -r -l -u ${uid} -g ${gid} -ms /bin/bash appuser
RUN usermod -aG sudo appuser
RUN echo 'appuser:nvidia' | chpasswd
RUN mkdir -p /workspace && chown appuser /workspace


# Install PyPI packages
RUN pip3 install --upgrade pip
RUN pip3 install setuptools>=41.0.0
COPY requirements.txt /tmp/requirements.txt
RUN pip3 install -r /tmp/requirements.txt

# Set environment and working directory
ENV TRT_LIBPATH /usr/lib/x86_64-linux-gnu
ENV TRT_OSSPATH /workspace/TensorRT
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${TRT_OSSPATH}/build/out:${TRT_LIBPATH}"
WORKDIR /workspace

RUN rm -f /tmp/nv-tensorrt-local-repo-${OS}-${TAG}_1.0-1_amd64.deb

USER appuser
RUN ["/bin/bash"]
