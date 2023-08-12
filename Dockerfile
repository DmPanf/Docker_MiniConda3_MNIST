# syntax=docker/dockerfile:1

###########################################
## docker.mfrg.su/jupyter-lab/Dockerfile ##
###########################################

# Copyright (c) Media Forge LLC. 2023

# Set the base image using miniconda
FROM continuumio/miniconda3

# Set metadata
LABEL "ru.mforge.vendor"="Media Forge LLC"
LABEL maintainer="m.panfilov@mforge.ru"
LABEL version="1.2"

# Set environmental variable(s)
ENV PYTHONUNBUFFERED=1

# Set working directory
WORKDIR /home/project

# Clean and update
RUN apt-get update -y \
    && apt-get clean -y \
    && apt-get update -qqq

# Install pandoc & tex
RUN apt-get install -y pandoc \
    texlive-xetex texlive-fonts-recommended texlive-plain-generic

# Install git, wget & curl
RUN apt-get install -y git wget curl

# Install NodeJS & npm
RUN apt-get install -y nodejs npm \
    && npm config rm proxy  \
    && npm config rm https-proxy

RUN curl -fsSL https://deb.nodesource.com/setup_current.x | bash - \
    && apt-get install -y nodejs

# Install basic packages
RUN conda install -y \
    jupyter \
    jupyterlab \
    nbconvert

# Install extension backend
RUN conda install -y -c conda-forge jupyter_nbextensions_configurator

# Install extensions
RUN jupyter lab clean

RUN jupyter labextension install --no-build \
    @jupyterlab/toc-extension \
    @aquirdturtle/collapsible_headings \
    @jupyter-widgets/jupyterlab-manager

RUN jupyter lab build --dev-build=False --minimize=False

# Run shell command for lab on start
CMD jupyter lab --ip="*" --port=8888 --no-browser --allow-root
