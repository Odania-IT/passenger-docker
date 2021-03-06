#!/bin/bash
set -e
source /build/buildconfig
source /etc/environment
set -x

## Install Phusion Passenger.
if [[ "$PASSENGER_ENTERPRISE" ]]; then
	apt-get install -y nginx-common passenger-enterprise
else
	apt-get install -y nginx-common passenger
fi
cp /build/config/nginx.conf /etc/nginx/nginx.conf
cp /build/config/webapp.conf /etc/nginx/webapp.conf.orig
cp /build/config/webapp-prod.conf /etc/nginx/webapp-prod.conf.orig
mkdir -p /etc/nginx/main.d
cp /build/config/nginx_main_d_default.conf /etc/nginx/main.d/default.conf
cp /build/config/mysql-env.conf /etc/nginx/main.d/mysql-env.conf
cp /build/config/redis-env.conf /etc/nginx/main.d/redis-env.conf
cp /build/config/elasticsearch-env.conf /etc/nginx/main.d/elasticsearch-env.conf
cp /build/config/mailcatcher-env.conf /etc/nginx/main.d/mailcatcher-env.conf
cp /build/config/app-env.conf /etc/nginx/main.d/app-env.conf
cp /build/config/mongoid-env.conf /etc/nginx/main.d/mongoid-env.conf

## Install Nginx runit service.
mkdir /etc/service/nginx
cp /build/runit/nginx /etc/service/nginx/run
touch /etc/service/nginx/down

mkdir /etc/service/nginx-log-forwarder
cp /build/runit/nginx-log-forwarder /etc/service/nginx-log-forwarder/run

## Precompile Ruby extensions.
ruby -S passenger-config build-native-support
setuser app ruby -S passenger-config build-native-support
