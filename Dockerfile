FROM phusion/baseimage:0.9.19
MAINTAINER Kaisar Arkhan (Yuki) <ykno@protonmail.com>

ENV DEBIAN_FRONTEND=noninteractive TERM=dumb

# Use the init system
CMD /sbin/my_init

# Update repository
RUN apt-get update

# Install planet-venus and lighttpd
RUN apt-get install -y planet-venus lighttpd

# Add update script
ADD update-page.sh /usr/bin/update-page

# Add lighttpd service
RUN mkdir -p /etc/service/lighttpd
ADD sv/lighttpd.sh /etc/service/lighttpd/run

# Add update-page one-shot
RUN mkdir -p /etc/my_init.d
ADD one-shot/update-page.sh /etc/my_init.d/update-page.sh

# Add crontab
ADD crontab /autoupdate-cron

# Add crontab to root's crontab
RUN crontab autoupdate-cron

# Grant execution rights to scripts and services
RUN chmod 0755 /usr/bin/update-page && \
    chmod 0755 /etc/service/lighttpd/run && \
    chmod 0755 /etc/my_init.d/update-page.sh

# Create a basic planet
RUN planet --create planet

# Link http root into planet folder
RUN rm -rf /var/www/html && \
    ln -s /planet/output /var/www/html

# Make planet folder into a volume
VOLUME /planet

# Expose port 80
EXPOSE 80
