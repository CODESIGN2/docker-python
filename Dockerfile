ARG PYTHON_VERSION
FROM python:${PYTHON_VERSION}-alpine
MAINTAINER codesign2@icloud.com

ENV PYTHON_VERSION=${PYTHON_VERSION}

# Build deps
RUN apk update \
  && apk add --no-cache git openssh-client

# Install Pipenv
RUN pip install pipenv

# Install testing utilities
RUN pip install pytest unittest2 nose2 hypothesis tox mock

# Install linting utilities
RUN pip install flake8 pytest-flakes

# Install testing utilities
RUN pip install bandit pytest-benchmark factory-boy freezegun faker coverage pytest-cov

# Install debugger beautification
RUN pip install pdbpp

# Adjust PATH
ENV PATH $PATH:/root/composer/vendor/bin
