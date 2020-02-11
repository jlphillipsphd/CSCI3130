FROM jupyter/base-notebook

LABEL maintainer="Joshua L. Phillips <https://www.cs.mtsu.edu/~jphillips/>"

USER root

# Additional tools
RUN apt-get update && \
    apt-get install -y \
    gcc \
    g++ \
    make \
    autoconf \
    libtool \
    vim \
    less \
    ssh \
    rsync \
    zip \
    tmux \
    gdb \
    && apt-get clean

# CSCI 3130
USER $NB_UID

RUN conda install --quiet --yes \
    bash_kernel \
    && \
    conda clean --all -f -y && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

