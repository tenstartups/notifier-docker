#
# Notifier docker image
#
# http://github.com/tenstartups/notifier-docker
#

FROM brigand/ruby

MAINTAINER Marc Lennox <marc.lennox@gmail.com>

# Set environment variables.
ENV \
  DEBIAN_FRONTEND=noninteractive \
  TERM=xterm-color

# Install packages.
RUN apk --update add build-base ruby-dev bash curl nano wget

# Install ruby gems.
RUN gem install colorize hipchat rest-client slack-notifier --no-ri --no-rdoc

# Set the working directory.
WORKDIR /home/notifier

# Add files to the container.
ADD . /home/notifier

# Copy scripts and configuration into place.
RUN \
  find ./script -type f -name '*.sh' | while read f; do echo 'n' | cp -iv "$f" "/usr/local/bin/`basename ${f%.sh}`" 2>/dev/null; done && \
  find ./script -type f -name '*.rb' | while read f; do echo 'n' | cp -iv "$f" "/usr/local/bin/`basename ${f%.rb}`" 2>/dev/null; done && \
  rm -rf ./script

# Define entrypoint script.
ENTRYPOINT ["./entrypoint"]

# Define default command.
CMD ["/usr/local/bin/notify"]
