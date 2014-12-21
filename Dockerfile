#
# Docker automated image builder dockerfile
#
# http://github.com/tenstartups/docker-autobuild-docker
#
FROM ubuntu:trusty

MAINTAINER Marc Lennox <marc.lennox@gmail.com>

# Set environment variables.
ENV DEBIAN_FRONTEND noninteractive
ENV GIT_SSH /usr/local/bin/git-ssh
ENV HOME /opt/autobuild

# Install base packages.
RUN apt-get update
RUN apt-get -y install \
  apt-transport-https \
  ca-certificates

# Install Docker from Docker Inc. repositories.
RUN \
  echo deb https://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list && \
  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9

# Install the rest of the base packages.
RUN apt-get update
RUN apt-get -y install \
  curl \
  daemontools \
  git \
  iptables \
  lxc \
  lxc-docker \
  nano \
  wget

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set the working directory.
WORKDIR /opt/autobuild

# Add files to the container.
ADD . /opt/autobuild
RUN \
  find ./script -regex '^.+\.sh$' -exec bash -c 'mv "{}" "$(echo {} | sed -En ''s/\.\\/script\\/\(.*\)\.sh/\\/usr\\/local\\/bin\\/\\1/p'')"' \; && \
  rm -rf ./script

# Define volumes.
VOLUME ["/etc/autobuild/env", "/var/lib/autobuild"]

# Define entrypoint script.
ENTRYPOINT ["./entrypoint"]

# Define default command.
CMD ["/usr/bin/envdir", "/etc/autobuild/env", "/usr/local/bin/docker-build"]
