# Copyright (C) The Arvados Authors. All rights reserved.
#
# SPDX-License-Identifier: Apache-2.0

# Based on Debian
FROM debian:bullseye-slim
MAINTAINER Arvados Package Maintainers <packaging@arvados.org>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -q
RUN apt-get install -yq --no-install-recommends gnupg apt-transport-https ca-certificates

# package keys
ADD 1078ECD7.key 561F9B9CAC40B2F7.key /tmp/
RUN cat /tmp/1078ECD7.key | apt-key add -
RUN cat /tmp/561F9B9CAC40B2F7.key | apt-key add -

# Add repos
ADD apt.arvados.org-stable.list /etc/apt/sources.list.d/
RUN echo deb https://oss-binaries.phusionpassenger.com/apt/passenger bullseye main > /etc/apt/sources.list.d/passenger.list

# Install arvados

RUN apt-get update -q
RUN apt-get install -yq --no-install-recommends arvados-api-server arvados-controller passenger ruby-dev
