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
ADD . /home/notifier

# Copy scripts and configuration into place.
RUN \
  find ./script -type f -name '*.sh' | while read f; do echo "$f -> /usr/local/bin/`basename ${f%.sh}`"; cp "$f" "/usr/local/bin/`basename ${f%.sh}`"; done && \
  find ./script -type f -name '*.rb' | while read f; do echo "$f -> /usr/local/bin/`basename ${f%.rb}`"; cp "$f" "/usr/local/bin/`basename ${f%.rb}`"; done && \
  rm -rf ./script

# Define entrypoint script.
ENTRYPOINT ["./entrypoint"]

# Define default command.
CMD ["/usr/local/bin/notify"]
