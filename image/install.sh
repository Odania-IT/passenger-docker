#!/bin/bash
set -e
source /build/buildconfig
set -x

/build/enable_repos.sh
/build/prepare.sh
#/build/pups.sh
/build/utilities.sh

/build/ruby2.1.sh

# Must be installed after Ruby, so that we don't end up with two Ruby versions.
/build/nginx-passenger.sh

# Setup background_worker service
/build/background_worker.sh

# Copy startscript
mkdir -p /etc/my_init.d
cp /build/my_init.d/select_type.sh /etc/my_init.d/select_type.sh

# Disable ssh
touch /etc/service/sshd/down

/build/finalize.sh
