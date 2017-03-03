FROM phusion/baseimage:0.9.19
MAINTAINER Kaisar Arkhan (Yuki) <ykno@protonmail.com>

ENV DEBIAN_FRONTEND=noninteractive TERM=dumb

# Use the init system
CMD /sbin/my_init

# Install planet-venus and lighttpd
RUN apt-get update && \
    apt-get install -y planet-venus lighttpd

# Add update script
ADD update-page.sh /usr/bin/update-page

# Add required folders for service and one-shot
RUN mkdir -p /etc/service/lighttpd && \
    mkdir -p /etc/my_init.d

# Add lighttpd service
ADD sv/lighttpd.sh /etc/service/lighttpd/run

# Add update-page one-shot
ADD one-shot/update-page.sh /etc/my_init.d/update-page.sh

# Add crontab
ADD crontab /etc/cron/crontab

# Grant execution rights to scripts and services
RUN chmod +x /usr/bin/update-page && \
    chmod +x /etc/service/lighttpd/run && \
    chmod +x /etc/my_init.d/update-page.sh

# Create a basic planet
RUN planet --create planet

# Link http root into planet folder
RUN rm -rf /var/www/html && \
    ln -s /planet/output /var/www/html

# Make planet folder into a volume
VOLUME /planet

# Expose port 80
EXPOSE 80

# Clean unneeded files
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
