#
# Notifier docker image
#
# http://github.com/tenstartups/notifier-docker
#

FROM tenstartups/alpine-ruby

MAINTAINER Marc Lennox <marc.lennox@gmail.com>

# Install ruby gems.
RUN gem install colorize hipchat rest-client slack-notifier --no-ri --no-rdoc

# Set the working directory.
WORKDIR /home/notifier

# Add files to the container.
COPY entrypoint.sh /entrypoint
ADD script /tmp/script

# Copy scripts and configuration into place.
RUN \
  find /tmp/script -type f -name '*.sh' | while read f; do cp -v "$f" "/usr/local/bin/`basename ${f%.sh}`"; done && \
  find /tmp/script -type f -name '*.rb' | while read f; do cp -v "$f" "/usr/local/bin/`basename ${f%.rb}`"; done && \
  rm -rf /tmp/script

# Define entrypoint script.
ENTRYPOINT ["/entrypoint"]

# Define default command.
CMD ["/usr/local/bin/notify"]
