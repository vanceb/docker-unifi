# Dockerfile to create a Ubiquity Controller

FROM debian:squeeze
MAINTAINER vanceb <vance@axxe.co.uk>

ENV DEBIAN_FRONTEND noninteractive
# we don't need and apt cache in a container
RUN echo "Acquire::http {No-Cache=True;};" > /etc/apt/apt.conf.d/no-cache

# Setup additional source repositories for software installation
# Unifi and MongoDB repositories to ensure latest versions used
RUN echo "deb http://www.ubnt.com/downloads/unifi/distros/deb/debian debian ubiquiti" >> /etc/apt/sources.list && \
    echo "deb http://downloads-distro.mongodb.org/repo/debian-sysvinit dist 10gen" >> /etc/apt/sources.list
RUN apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com C0A52C50 7F0CEB10

# Update sources and install Unifi Controller, which pulls MongoDB and other dependencies
RUN apt-get update && apt-get -y install unifi

# Unifi starts it's own instance of MongoDB so let's make sure we don't run
# the standard copy we have just installed
# TODO...

# Copy the setup script for the data container
COPY unifi/ /unifi/

# Repoint the symlinks for logs and data
RUN rm /usr/lib/unifi/data && ln -s /unifi/data /usr/lib/unifi/data
RUN rm /usr/lib/unifi/logs && ln -s /unifi/logs /usr/lib/unifi/logs

# Expose the ports necessary for the Unifi Controller
# http://wiki.ubnt.com/UniFi_FAQ#How_can_I_run_UniFi_Controller_on_different_ports
# https://community.ubnt.com/t5/UniFi-Wireless/Which-ports-need-to-be-accessible-by-the-AP-s/td-p/546580

EXPOSE 3478/udp 8080 8081 8443 8843 8880

# Setup the command to run the controller
CMD ["/usr/lib/jvm/java-6-openjdk/jre/bin/java", "-Xmx1024M", "-jar", "/usr/lib/unifi/lib/ace.jar", "start"]
