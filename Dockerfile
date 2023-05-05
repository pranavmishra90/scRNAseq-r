FROM satijalab/seurat:latest as backend

#########################
ARG IMAGE_VERSION="0.0.1"
#########################

LABEL org.opencontainers.image.title="scRNAseq on Docker"
LABEL version=${IMAGE_VERSION}}
LABEL org.opencontainers.image.version=${IMAGE_VERSION}}
LABEL org.opencontainers.image.authors='Pranav Kumar Mishra'
LABEL description="Single Cell RNA sequencing experiments in a reproducible research environment"
LABEL org.opencontainers.image.source="https://github.com/pranavmishra90/scRNAseq-r"
LABEL org.opencontainers.image.licenses="MIT"

# Install system dependencies
RUN apt-get update
RUN apt-get install -y \
    parallel \
    pandoc \
    libbz2-dev \
    liblzma-dev \
    libfontconfig1-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libfreetype6-dev \
    libpng-dev \
    libtiff5-dev \
    libjpeg-dev \
    gdebi-core \
    pandoc \
    pandoc-citeproc \
    python3-tables \
    curl \ 
    wget \
    && rm -rf /var/lib/apt/lists/*


## Install Quarto
RUN wget --no-check-certificate -O /root/quarto-linux-amd64.deb https://quarto.org/download/latest/quarto-linux-amd64.deb
RUN gdebi --non-interactive /root/quarto-linux-amd64.deb

## Install Python
RUN wget --no-check-certificate -O /root/Mambaforge.sh  https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-Linux-x86_64.sh
RUN bash /root/Mambaforge.sh -b

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

FROM rocker/rstudio:latest-daily

LABEL org.opencontainers.image.licenses="GPL-2.0-or-later" \
      org.opencontainers.image.source="https://github.com/rocker-org/rocker-versioned2" \
      org.opencontainers.image.vendor="Rocker Project" \
      org.opencontainers.image.authors="Carl Boettiger <cboettig@ropensci.org>"

RUN /rocker_scripts/install_tidyverse.sh

FROM ubuntu:latest as mergeall
WORKDIR /home/rstudio/
CMD ["/init"]

#Copyright 2023 Pranav Kumar Mishra
#SPDX-License-Identifier: Apache-2.0