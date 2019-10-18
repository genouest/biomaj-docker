#!/bin/bash

set -e

TS=$(date +%s)
USER="biomaj$TS"

APIKEY=`docker-compose exec biomaj-user-web biomaj-users.py -A add -E biomaj@fake.fr -U $USER -P biomaj --json | jq -r '.apikey'`
echo "APIKEY=$APIKEY"
echo "update alu"

docker-compose exec biomaj-user-web biomaj-cli.py --proxy http://biomaj-public-proxy --api-key $APIKEY --update --bank alu

count=0

while true; do
    sleep 60
    echo "Check alu update status"
    PROD=`docker-compose exec biomaj-user-web biomaj-cli.py --proxy http://biomaj-public-proxy --api-key $APIKEY --status --bank alu --json | jq '.bank.production.details[0]'`
    echo "PROD = $PROD"
    if [ "$PROD" == "null" ]; then
        echo "Not updated yet, trying again..."
	(( count++ ))
	if test $count -eq 5
        then
            echo "Still failing after 5 minutes"
	    exit 1
	fi
    else
        echo "Success"
        break
    fi
done
docker-compose exec biomaj-user-web biomaj-cli.py --proxy http://biomaj-public-proxy --api-key $APIKEY --status --bank alu
