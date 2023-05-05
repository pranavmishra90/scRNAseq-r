FROM ubuntu:22.04

#########################
ARG IMAGE_VERSION="0.0.1"
#########################

LABEL org.opencontainers.image.title="scRNAseq on Docker"
LABEL version=${IMAGE_VERSION}}
LABEL org.opencontainers.image.version=${IMAGE_VERSION}}
LABEL org.opencontainers.image.authors='Pranav Kumar Mishra'
LABEL description="Single Cell RNA sequencing experiments in a reproducible research environment"
LABEL org.opencontainers.image.source="https://github.com/pranavmishra90/scRNAseq-r"
LABEL org.opencontainers.image.licenses="Apache-2.0"


# General Parameters
WORKDIR /home/r-studio


# Add packages and update overall installation
RUN --mount=type=cache,target=/var/cache/apt \
	apt-get update && \
	apt-get install -y --no-install-recommends \
    curl \
    gdebi-core \
    systemd \
    wget \
	yadm \
    && rm -rf /var/lib/apt/lists/*

## Install Python
RUN wget -O Mambaforge.sh https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-Linux-x86_64.sh

RUN bash /home/r-studio/Mambaforge.sh -b
# RUN bash /home/r-studio/conda/etc/profile.d/mamba.sh

##3 Install Python packages
COPY python-environment.yaml /home/r-studio/python-environment.yaml

# RUN mamba env create -f python-environment.yaml
# RUN mamba activate molbio
















CMD ["/init"]

#Copyright 2023 Pranav Kumar Mishra
#SPDX-License-Identifier: Apache-2.0