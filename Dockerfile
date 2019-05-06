FROM alpine:3.4
MAINTAINER codesign2@icloud.com

# ensure local python is preferred over distribution python
ENV PATH /usr/local/bin:$PATH

# http://bugs.python.org/issue19846
# > At the moment, setting "LANG=C" on a Linux system *fundamentally breaks Python 3*, and that's not OK.
ENV LANG C.UTF-8

# install ca-certificates so that HTTPS works consistently
# the other runtime dependencies for Python are installed later
RUN apk add --no-cache ca-certificates

ENV PYTHON_VERSION 2.5.4

# if this is called "PIP_VERSION", pip explodes with "ValueError: invalid truth value '<VERSION>'"
ENV PYTHON_PIP_VERSION 8.1.2

RUN mkdir -p /usr/src/python
COPY patches /tmp/patches

# Barry warsaw (of debian) key
ENV PYTHON_GPG_KEY=8417157EDBE73D9EAC1E539B126EB563A74B06BF

RUN set -ex \
    && apk add --no-cache --virtual .fetch-deps \
        openssl \
        gnupg \
        tar \
        bzip2 \
    \
    && wget -O python.tar.bz2 "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.bz2" \
    && tar -xjC /usr/src/python --strip-components=1 -f python.tar.bz2 \
    && rm python.tar.bz2

RUN apk add --no-cache --virtual .build-deps  \
        gcc \
        libc-dev \
        linux-headers \
        make \
        build-base \
        autoconf \
        automake \
        openssl \
        readline-dev \
        tcl-dev \
        tk \
        tk-dev \
        expat-dev \
        openssl-dev \
        zlib-dev \
        ncurses-dev \
        bzip2-dev \
        gdbm-dev \
        sqlite-dev \
        libffi-dev \
# add build deps before removing fetch deps in case there's overlap
    && apk del .fetch-deps

RUN cd /usr/src/python \
    && mv /tmp/patches/*.patch ./ \
    && ls -la \
    && for patchfile in *.patch ; do \
    patch -p1 -u -i ${patchfile}; \
    done && \
    ./configure --prefix=/usr \
    --enable-shared \
    --with-threads \
    --with-system-ffi \
    --enable-unicode=ucs4 \
    && make -j$(getconf _NPROCESSORS_ONLN) \
    && make install \
    && ln -s /usr/bin/python2.5 /usr/bin/python2 \
        && wget -O /tmp/pip.zip https://github.com/pypa/pip/archive/1.0.2.zip \
        && wget -O /tmp/setuptools.zip https://github.com/pypa/setuptools/archive/1.4.2.zip \
        && cd /tmp && unzip pip.zip && unzip setuptools.zip \
        && cd /tmp/setuptools-1.4.2 && python setup.py install \
        && easy_install /tmp/pip-1.0.2 \
        && rm -rf /tmp/* \
    && runDeps="$( \
        scanelf --needed --nobanner --recursive /usr/local \
            | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
            | sort -u \
            | xargs -r apk info --installed \
            | sort -u \
    )" \
    && apk add --virtual .python-rundeps $runDeps \
    && apk del .build-deps \
    && rm -rf /usr/src/python ~/.cache

# Build deps
RUN apk update \
  && apk add --no-cache git openssh-client

# Pipenv did not exist at this point

# Install testing utilities
RUN pip install pytest unittest2 nose2 hypothesis tox mock

# Install linting utilities
RUN pip install flake8==3.2.1 pytest-flakes==2.0.0

# Install testing utilities
RUN pip install bandit pytest-benchmark factory-boy freezegun faker coverage pytest-cov

# Install debugger beautification
RUN pip install pdbpp==0.8 fancycompleter==0.7

# Adjust PATH
ENV PATH $PATH:/root/composer/vendor/bin
