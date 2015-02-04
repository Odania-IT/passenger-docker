FROM phusion/baseimage:latest
MAINTAINER Mike Petersen <mike@odania-it.de>

ENV HOME /root
RUN mkdir /build
ADD . /build
RUN /build/install.sh
CMD ["/sbin/my_init"]
