#
# Notifier dockerfile
#
# http://github.com/tenstartups/notifier-docker
#
FROM debian:jessie

MAINTAINER Marc Lennox <marc.lennox@gmail.com>

# Set environment variables.
ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm-color

# Install base packages.
RUN apt-get update
RUN apt-get -y install \
  build-essential \
  curl \
  daemontools \
  libcurl4-openssl-dev \
  libssl-dev \
  libyaml-dev \
  nano \
  wget \
  zlib1g-dev

# Compile ruby from source.
RUN \
  cd /tmp && \
  wget http://ftp.ruby-lang.org/pub/ruby/2.2/ruby-2.2.0.tar.gz && \
  tar -xzvf ruby-*.tar.gz && \
  rm -f ruby-*.tar.gz && \
  cd ruby-* && \
  ./configure --enable-shared --disable-install-doc && \
  make && \
  make install && \
  cd .. && \
  rm -rf ruby-*

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install ruby gems.
RUN gem install awesome_print hipchat rest-client slack-notifier --no-ri --no-rdoc

# Set the working directory.
WORKDIR /opt/notifier

# Add files to the container.
ADD . /opt/notifier
RUN \
  find ./script -iname '*.rb' -exec bash -c 'mv -v "{}" "$(echo {} | sed -En ''s/\.\\/script\\/\(.*\)\.rb/\\/usr\\/local\\/bin\\/\\1/p'')"' \; && \
  rm -rf ./script

# Define volumes.
VOLUME ["/etc/notifier/env"]

# Define entrypoint script.
ENTRYPOINT ["./entrypoint"]

# Define default command.
CMD ["/usr/bin/envdir", "/etc/notifier/env", "/usr/local/bin/notify"]
