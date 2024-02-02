FROM nvidia/cuda:11.5.2-cudnn8-runtime-ubuntu20.04

LABEL maintainer="tannousgeagea@hotmail.com"
LABEL version="1.1b1"

ARG user
ARG userid
ARG group
ARG groupid

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

# # Set up users and groups
RUN addgroup --gid $groupid $group && \
	adduser --uid $userid --gid $groupid --disabled-password --gecos '' --shell /bin/bash $user && \
	echo "$user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$user && \
	chmod 0440 /etc/sudoers.d/$user

# Set the working directory in the container
RUN mkdir -p /home/$user/src
RUN mkdir -p /home/$user/data
RUN mkdir -p /home/$user/logs

WORKDIR /home/$user/src

# install pyython packages
COPY ./requirements.txt /home/$user/src
RUN pip3 install --no-cache-dir -r requirements.txt

# Entrypoint
COPY ./entrypoint.sh /home/.
RUN /bin/bash -c "chown $user:$user /home/entrypoint.sh"
# ENTRYPOINT /bin/bash -c ". /home/entrypoint.sh"