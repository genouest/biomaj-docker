#!/bin/bash

set -e

BANK=$1
TS=$(date +%s)
USER="biomaj$TS"
docker compose ps
APIKEY=`docker compose exec biomaj-user-web python3 /usr/local/bin/biomaj-users.py -A add -E biomaj@fake.fr -U $USER -P biomaj --json | jq -r '.apikey'`
echo "APIKEY=$APIKEY"
echo "update $BANK"

echo "biomaj-cli begin"
docker compose exec biomaj-user-web biomaj-cli.py --proxy http://biomaj-public-proxy --api-key $APIKEY --update --bank $BANK
echo "biomaj-cli end"

count=0

while true; do
    docker compose exec biomaj-user-web biomaj-cli.py --proxy http://biomaj-public-proxy --api-key $APIKEY --status --bank $BANK 
    sleep 60
    echo "Check $BANK update status"
    PROD=`docker compose exec biomaj-user-web biomaj-cli.py --proxy http://biomaj-public-proxy --api-key $APIKEY --status --bank $BANK --json | jq '.bank.production.details[0]'`
    echo "PROD = $PROD"
    if [ "$PROD" == "null" ]; then
        echo "Not updated yet, trying again..."
	count=$((count+1))
	if test $count -eq 5
        then
            echo "Still failing after 5 minutes"
            docker compose logs biomaj-daemon-message
	    docker compose logs biomaj-download-web
	    docker compose logs biomaj-download-message
	    exit 1
	fi
    else
        echo "Success"
        break
    fi
done
docker compose exec biomaj-user-web biomaj-cli.py --proxy http://biomaj-public-proxy --api-key $APIKEY --status --bank $BANK

