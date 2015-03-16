# passenger-docker

Docker base image for Ruby on Rails applications. It uses Ruby 2.1.

I am using https://github.com/jwilder/docker-register so only one port is allowed to be exported. Only port EXPOSE_PORT (e.g. 80) is exposed if additionally ssl is needed the proxy (e.g. nginx) has to handle the ssl part.

Some basics are based on the good work of: https://github.com/phusion/passenger-docker

In order to use this image you need to set these environment variables:
```
RAILS_ENV
EXPOSE_PORT
PROCESS_TYPE
```

The RAILS_ENV is set as rails environment in the app. The EXPOSE_PORT is the port the container exposes the http server on. Due to the usage of docker-register/docker-discover each app needs to be on a separate port.
All apps exposing the same port will be mapped as additional server for the same app. 

The PROCESS_TYPE environment variable can be set to "web" or "background_worker". If it is set to web passenger will be started and serve the app. If set to background_worker it will start a background processing service.
Per default it will start sidekiq as a background worker. If you want to use another service put a file with a content like:
```
#!/bin/bash
set -e
cd /home/app/webapp
exec bundle exec sidekiq -e $RAILS_ENV
```
This file needs to put to the folder: /etc/service/background_worker/run.
In a Dockerfile you can use
```
ADD my_own_background_worker.sh /etc/service/background_worker/run
```

For a rails app you can create a Dockerfile with this content:
```
FROM mikepetersen/passenger-docker:latest
MAINTAINER Mike Petersen "mike@odania-it.de"

# Set correct environment variables.
ENV HOME /home/app/webapp

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# Start Nginx / Passenger
RUN rm -f /etc/service/nginx/down

# Remove the default site
RUN rm /etc/nginx/sites-enabled/default

# Prepare folders
RUN mkdir /home/app/webapp

# Add the rails app
ADD . /home/app/webapp

WORKDIR /home/app/webapp
RUN chown -R app:app /home/app/webapp
RUN sudo -u app bundle install --deployment
RUN bundle exec rake assets:precompile

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
```
