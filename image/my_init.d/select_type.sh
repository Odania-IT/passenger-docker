#!/bin/bash
set -e

if [ ! -z "$PROCESS_TYPE" ] && [ $PROCESS_TYPE == 'background_worker' ]
then
	echo "Starting background worker"
	rm -f /etc/service/background_worker/down
else
	echo "Starting nginx+passenger web process"
	rm -f /etc/service/nginx/down
fi
