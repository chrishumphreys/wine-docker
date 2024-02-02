# Docker container running Wine under X to a framebuffer accessible via noVNC from a browser
# A base image for extending with windows tools you wish to run
# Based on https://github.com/solarkennedy/wine-x11-novnc-docker/blob/master/Dockerfile
#
FROM ubuntu:focal

ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

RUN dpkg --add-architecture i386 && \
    apt-get update && apt-get -y install python2 python-is-python2 xvfb x11vnc xdotool wget tar supervisor net-tools fluxbox gnupg2
    
RUN wget -O - https://dl.winehq.org/wine-builds/winehq.key | apt-key add -  && \
    echo 'deb https://dl.winehq.org/wine-builds/ubuntu/ focal main' |tee /etc/apt/sources.list.d/winehq.list
    
RUN apt-get update && apt-get -y install winehq-stable

# Install and unpack Wine-mono as shared install
RUN mkdir -p /usr/share/wine/mono && wget -O /usr/share/wine/mono/wine-mono-8.1.0-x86.tar.xz https://dl.winehq.org/wine/wine-mono/8.1.0/wine-mono-8.1.0-x86.tar.xz
RUN cd /usr/share/wine/mono/ && tar -xJf wine-mono-8.1.0-x86.tar.xz

# Install and unpack Wine-gecko (for html .net component) as shared install
RUN mkdir -p /usr/share/wine/gecko && wget -O /usr/share/wine/gecko/wine-gecko-2.47.3-x86.tar.xz https://dl.winehq.org/wine/wine-gecko/2.47.3/wine-gecko-2.47.3-x86.tar.xz
RUN cd /usr/share/wine/gecko && tar xJf wine-gecko-2.47.3-x86.tar.xz

# Setup X and auto start    
RUN apt-get -y full-upgrade && apt-get clean && rm -rf /var/lib/apt/lists/*
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

ENV WINEPREFIX /root/prefix32
ENV WINEARCH win32
ENV DISPLAY :0

# Install novnc
WORKDIR /root/
RUN wget -O - https://github.com/novnc/noVNC/archive/v1.1.0.tar.gz | tar -xzv -C /root/ && mv /root/noVNC-1.1.0 /root/novnc && ln -s /root/novnc/vnc_lite.html /root/novnc/index.html && \
    wget -O - https://github.com/novnc/websockify/archive/v0.9.0.tar.gz | tar -xzv -C /root/ && mv /root/websockify-0.9.0 /root/novnc/utils/websockify

EXPOSE 8080

CMD ["/usr/bin/supervisord"]

