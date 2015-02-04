#!/bin/bash
set -e
source /build/buildconfig
source /etc/environment
set -x

## Install background_worker runit service.
mkdir /etc/service/background_worker
cp /build/runit/background_worker /etc/service/background_worker/run
touch /etc/service/background_worker/down
