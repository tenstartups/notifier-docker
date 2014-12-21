#
# Notifier dockerfile
#
# http://github.com/tenstartups/notifier-docker
#
FROM debian:jessie

MAINTAINER Marc Lennox <marc.lennox@gmail.com>

# Set environment variables.
ENV DEBIAN_FRONTEND noninteractive

# Install base packages.
RUN apt-get update
RUN apt-get -y install \
  curl \
  daemontools \
  nano \
  wget

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set the working directory.
WORKDIR /opt/notifier

# Add files to the container.
ADD . /opt/notifier
RUN \
  find ./script -regex '^.+\.sh$' -exec bash -c 'mv "{}" "$(echo {} | sed -En ''s/\.\\/script\\/\(.*\)\.sh/\\/usr\\/local\\/bin\\/\\1/p'')"' \; && \
  rm -rf ./script

# Define volumes.
VOLUME ["/etc/notifier/env"]

# Define entrypoint script.
ENTRYPOINT ["./entrypoint"]

# Define default command.
CMD ["/usr/bin/envdir", "/etc/notifier/env", "/usr/local/bin/notify"]
