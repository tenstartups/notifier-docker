#
# Notifier docker image
#
# http://github.com/tenstartups/notifier-docker
#

FROM ruby:slim

MAINTAINER Marc Lennox <marc.lennox@gmail.com>

# Set environment variables.
ENV \
  DEBIAN_FRONTEND=noninteractive \
  TERM=xterm-color

# Install base packages.
RUN apt-get update && apt-get -y install \
  build-essential \
  curl \
  nano \
  wget

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install ruby gems.
RUN gem install awesome_print rest-client slack-notifier --no-ri --no-rdoc
RUN gem install hipchat --version='1.4.0' --no-ri --no-rdoc

# Set the working directory.
WORKDIR /home/notifier

# Add files to the container.
ADD . /home/notifier

# Copy scripts and configuration into place.
RUN \
  find ./script -regextype posix-extended -regex '^.+\.(rb|sh)\s*$' -exec bash -c 'f=`basename "{}"`; mv -v "{}" "/usr/local/bin/${f%.*}"' \; && \
  rm -rf ./script

# Define entrypoint script.
ENTRYPOINT ["./entrypoint"]

# Define default command.
CMD ["/usr/local/bin/notify"]
