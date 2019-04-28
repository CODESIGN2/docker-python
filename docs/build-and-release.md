# Build and release documentation

This documentation serves as a description of manual steps to build and release this repository. 

## Prerequisites

In order to build this there are relatively few dependencies.

- A Dockerhub account
- The docker daemon installed and able to run on your OS as your user
- Your credentials for said daemon to auth to dockerhub
- A copy of the source code in this repository (assumed you have if you are reading)

1. You MUST have internet connectivity in order to use this repository
2. You MUST login to your dockerhub account IF you wish to push beyond your machine
3. You MUST have cloned this repository onto your machine
4. You SHOULD operate from within this repository current directory as the basis for where to run commands

## Building

Python runtimes should always be at the latest building patch version, where building relates to the ability of this repository to build, not the abstract ability to compile a python interpreter.

To build all current (at the time of writing) python runtime images run the following

```shell
docker build -t cd2team/docker-python:2.7 --build-arg PYTHON_VERSION=2.7 --no-cache .
docker build -t cd2team/docker-python:3.5 --build-arg PYTHON_VERSION=3.5 --no-cache .
docker build -t cd2team/docker-python:3.6 --build-arg PYTHON_VERSION=3.6 --no-cache .
docker build -t cd2team/docker-python:3.7 --build-arg PYTHON_VERSION=3.7 --no-cache .
docker build -t cd2team/docker-python:3.8 --build-arg PYTHON_VERSION=rc --no-cache .
```

## Releasing

Should you wish to release (CD2 internal organisation below), you can run the following commands to deploy your built images.

```shell
docker push cd2team/docker-python:2.7
docker push cd2team/docker-python:3.5
docker push cd2team/docker-python:3.6
docker push cd2team/docker-python:3.7
docker push cd2team/docker-python:3.8
```

## Special tags

To facilitate best-practices in continuous delivery according to CODESIGN2 team principles simple tags are used as special cases to convey breifly the python runtime. It should be considered that all code marked 2 will run in all 2.x active runtimes, where runtimes should be listed. The same should be said for 3 and 3.x. rc is a special case that represents the future of the python 3 runtime at present and may fail to build or be omitted at the discretion of the builder / build-system.

### Tagging

```shell
docker tag cd2team/docker-python:3.8 cd2team/docker-python:rc
docker tag cd2team/docker-python:3.7 cd2team/docker-python:3
docker tag cd2team/docker-python:2.7 cd2team/docker-python:2
```

### Releasing (push to registry)

```shell
docker push cd2team/docker-python:2
docker push cd2team/docker-python:3
docker push cd2team/docker-python:rc
```

It should be noted that the expectation that code marked will run only applies as far as the build process and is not a statement of intent to support specific application or implementation details. Applications should shape themselves to fit he CI & CD service(s).


## Why not just use {build-service}?

This repository was setup to use CD2 internal Jenkins & Travis CI. Travis CI has been activated, but either due to Travis or Github changes it doesn't seem to be able to build at the time of writing this documentation. The CD2 Jenkins is internal and not for public access. This should not matter, and the repository should be able to build vendor independently.