#!/bin/bash

cd /root/biomaj-watcher && gunicorn -b 0.0.0.0:5000 --log-config=/etc/biomaj/production.ini --paste /etc/biomaj/production.ini
