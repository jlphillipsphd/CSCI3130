FROM jupyter/base-notebook:ubuntu-22.04

LABEL maintainer="Joshua L. Phillips <https://www.cs.mtsu.edu/~jphillips/>"
LABEL release-date="2022-08-11"

USER root

RUN echo -e "y\ny" | unminimize

# Additional tools
RUN apt-get update && \
    apt-get install -y \
    autoconf \
    curl \
    emacs-nox \
    enscript \
    g++ \
    gcc \
    gdb \
    less \
    libtool \
    make \
    man-db \
    rsync \
    screen \
    ssh \
    time \
    tmux \
    vim \
    zip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install:
# VSCode (for IDE)
RUN curl -fsSL https://code-server.dev/install.sh | sh -s -- --version=4.5.1 && \
    rm -rf "${HOME}/.cache"

USER $NB_UID

# Simple proxy-friendly stack
RUN mamba install --yes \
    jupyter-server-proxy \
    websockify && \
    mamba clean --all -f -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

# JS-Proxy package(s) configuration:
# jupyter_codeserver_proxy (for IDE)
# ENV CODE_WORKINGDIR="${HOME}"
COPY ./dist/*.whl /${HOME}/
RUN pip install --quiet --no-cache-dir *.whl && \
    rm *.whl && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

# Other root operations that can't (or maybe just shouldn't)
# be performed until the packages above are installed...
USER root

# Custom hook to setup home directory
RUN mkdir /usr/local/bin/before-notebook.d
COPY config-home.sh /usr/local/bin/before-notebook.d/.

# Switch back to user for final env
# configuration...
USER $NB_UID

# Configure user environment (gets copied from /home/jovyan)
RUN cp /etc/skel/.bash_logout /etc/skel/.bashrc /etc/skel/.profile /home/${NB_USER}/. && conda init
