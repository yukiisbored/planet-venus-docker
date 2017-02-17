FROM ubuntu:latest
MAINTAINER Kaisar Arkhan (Yuki) <ykno@protonmail.com>

ENV DEBIAN_FRONTEND=noninteractive TERM=dumb

# Update repository
RUN apt-get update

# Install cron, planet-venus, lighttpd
RUN apt-get install -y cron planet-venus lighttpd

# Add update script
ADD update-page.sh /usr/bin/update-page

# Add crontab
ADD crontab /etc/cron.d/autoupdate

# Grant execution rights to cron job and update script
RUN chmod 0644 /etc/cron.d/autoupdate && \
    chmod 0755 /usr/bin/update-page

# Create a basic planet
RUN planet --create planet

# Link http root into planet folder
RUN rm -rf /var/www/html && \
    ln -s /planet/output /var/www/html

# Make planet folder into a volume
VOLUME /planet

# Expose port 80
EXPOSE 80

# Generate pages and start cron daemon + lighttpd
CMD update-page && cron && lighttpd -D -f /etc/lighttpd/lighttpd.conf
