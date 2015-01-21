FROM phusion/baseimage:0.9.15
MAINTAINER Mike Petersen <mike@odania-it.de>

ENV HOME /root
RUN mkdir /build
ADD . /build
RUN /build/install.sh
CMD ["/sbin/my_init"]
EXPOSE $EXPOSE_PORT
