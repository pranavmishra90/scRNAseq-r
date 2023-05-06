# syntax = docker/dockerfile:1.2
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
# WORKDIR /home/r-studio


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
# RUN wget -O Mambaforge.sh https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-Linux-x86_64.sh
COPY Mambaforge.sh /home/r-studio/Mambaforge.sh
RUN bash /home/r-studio/Mambaforge.sh -b
RUN bash /home/r-studio/mambaforge/etc/profile.d/mamba.sh

##3 Install Python packages
COPY python-environment.yaml /home/r-studio/python-environment.yaml

RUN mamba env create -f python-environment.yaml
# RUN mamba activate molbio
# Dockerfile for Seurat 4.3.0
FROM rocker/r-ver:4.2.0

## R environments

# Set global R options
RUN echo "options(repos = 'https://cloud.r-project.org')" > $(R --no-echo --no-save -e "cat(Sys.getenv('R_HOME'))")/etc/Rprofile.site
ENV RETICULATE_MINICONDA_ENABLED=FALSE

# Install Seurat's system dependencies

RUN --mount=type=cache,target=/var/cache/apt \
	apt-get update && \
	apt-get install -y --no-install-recommends \
    libhdf5-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libpng-dev \
    libboost-all-dev \
    libxml2-dev \
    openjdk-8-jdk \
    python3-dev \
    python3-pip \
    libfftw3-dev \
    libgsl-dev \
    pkg-config

RUN apt-get install -y llvm-10

# Install system library for rgeos
RUN apt-get install -y libgeos-dev

# Install UMAP
RUN LLVM_CONFIG=/usr/lib/llvm-10/bin/llvm-config pip3 install llvmlite
RUN pip3 install numpy
RUN pip3 install umap-learn

# Install FIt-SNE
RUN git clone --branch v1.2.1 https://github.com/KlugerLab/FIt-SNE.git
RUN g++ -std=c++11 -O3 FIt-SNE/src/sptree.cpp FIt-SNE/src/tsne.cpp FIt-SNE/src/nbodyfft.cpp  -o bin/fast_tsne -pthread -lfftw3 -lm

# Install bioconductor dependencies & suggests
RUN R --no-echo --no-restore --no-save -e "install.packages('BiocManager')"
RUN R --no-echo --no-restore --no-save -e "BiocManager::install(c('multtest', 'S4Vectors', 'SummarizedExperiment', 'SingleCellExperiment', 'MAST', 'DESeq2', 'BiocGenerics', 'GenomicRanges', 'IRanges', 'rtracklayer', 'monocle', 'Biobase', 'limma', 'glmGamPoi'))"

# Install CRAN suggests
RUN R --no-echo --no-restore --no-save -e "install.packages(c('VGAM', 'R.utils', 'metap', 'Rfast2', 'ape', 'enrichR', 'mixtools'))"

# Install spatstat
RUN R --no-echo --no-restore --no-save -e "install.packages(c('spatstat.explore', 'spatstat.geom'))"

# Install hdf5r
RUN R --no-echo --no-restore --no-save -e "install.packages('hdf5r')"

# Install latest Matrix
RUN R --no-echo --no-restore --no-save -e "install.packages('Matrix')"

# Install rgeos
RUN R --no-echo --no-restore --no-save -e "install.packages('rgeos')"

# Install Seurat
RUN R --no-echo --no-restore --no-save -e "install.packages('remotes')"
RUN R --no-echo --no-restore --no-save -e "install.packages('Seurat')"

# Install SeuratDisk
RUN R --no-echo --no-restore --no-save -e "remotes::install_github('mojaveazure/seurat-disk')"





ENV RSTUDIO_VERSION=2023.03.0+386
ENV R_HOME=/home/pranav/R
ENV TZ=America/Chicago
ENV DEFAULT_USER=rstudio
ENV PANDOC_VERSION=default
ENV QUARTO_VERSION=default

RUN /rocker_scripts/install_rstudio.sh
RUN /rocker_scripts/install_pandoc.sh
RUN /rocker_scripts/install_quarto.sh

EXPOSE 8787










CMD ["/init"]

#Copyright 2023 Pranav Kumar Mishra
#SPDX-License-Identifier: Apache-2.0