# Copyright (C) The Arvados Authors. All rights reserved.
#
# SPDX-License-Identifier: Apache-2.0

# Dockerfile for building an arvados/jobs Docker image from local git tree.
#
# Intended for use by developers working on arvados-python-client or
# arvados-cwl-runner and need to run a crunch job with a custom package
# version.
#
# Use arvados/build/build-dev-docker-jobs-image.sh to build.
#
# (This dockerfile file must be located in the arvados/sdk/ directory because
#  of the docker build root.)

FROM debian:jessie
MAINTAINER Ward Vandewege <ward@curoverse.com>

ENV DEBIAN_FRONTEND noninteractive

ARG pythoncmd=python

RUN apt-get update -q && apt-get install -qy --no-install-recommends \
    git ${pythoncmd}-pip ${pythoncmd}-virtualenv ${pythoncmd}-dev libcurl4-gnutls-dev \
    libgnutls28-dev nodejs ${pythoncmd}-pyasn1-modules build-essential

RUN if [ "$pythoncmd" = "python3" ]; then \
       pip3 install -U setuptools six requests ; \
    else \
       pip install -U setuptools six requests ; \
    fi

ARG sdk
ARG runner
ARG salad
ARG cwltool

ADD python/dist/$sdk /tmp/
ADD cwl/salad_dist/$salad /tmp/
ADD cwl/cwltool_dist/$cwltool /tmp/
ADD cwl/dist/$runner /tmp/

RUN cd /tmp/arvados-python-client-* && $pythoncmd setup.py install
RUN if test -d /tmp/schema-salad-* ; then cd /tmp/schema-salad-* && $pythoncmd setup.py install ; fi
RUN if test -d /tmp/cwltool-* ; then cd /tmp/cwltool-* && $pythoncmd setup.py install ; fi
RUN cd /tmp/arvados-cwl-runner-* && $pythoncmd setup.py install

# Install dependencies and set up system.
RUN /usr/sbin/adduser --disabled-password \
      --gecos 'Crunch execution user' crunch && \
    /usr/bin/install --directory --owner=crunch --group=crunch --mode=0700 /keep /tmp/crunch-src /tmp/crunch-job

USER crunch
