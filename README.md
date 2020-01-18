# CSCI3130
Docker container for CSCI 3130 - Assembly and Computer Organization

This container is built on top of jupyter/base-notebook provided by jupyter/docker-stacks. It provides a JupyterLab environment with a couple of essential (and non-essential) build tools used in CSCI3130 - Assembly and Computer Organization.

To prep:
```
git clone https://github.com/jlphillipsphd/CSCI3130.git
```
 
To build:
```
docker build -t csci3130 CSCI3130
```

To run:
```
docker run -it --rm -p 8888:8888 --user root -e JUPYTER_ENABLE_LAB=yes -e GRANT_SUDO=yes -v /home/jphillips:/home/jovyan/work csci3130
```

You will need to modify `/home/jphillips` to where your files are in order to make this work...

