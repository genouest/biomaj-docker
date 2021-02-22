# Requirements

* biomaj docker image osallou/biomaj-docker tag > massala
* biomaj-watcher >= 3.1.3

# Running

Execute docker-compose to launch all services.

you need to create a .env file in docker-compose.yml directory with:

    BIOMAJ_DIR=/..path_to.../biomaj-docker
    # optional location of data directory (downloaded and processes files)
    # default is to use global.properties data.dir location
    BIOMAJ_DATA_DIR=/..path_to_biomaj_data_dir_in_container
    # location of data directory on host (not container, /db for example)
    # used for biomaj-process with Docker executor
    # Ideally BIOMAJ_HOST_DATA_DIR should equal BIOMAJ_DATA_DIR
    BIOMAJ_HOST_DATA_DIR=/..path_to_biomaj_data_dir_on_host
    BIOMAJ_USER_PASSWORD=biomaj_user_default_password
    DOCKER_URL=tcp://x.y.z:2375  # if you wish to execute processes in Docker containers, give the IP of the host where docker is running (or swarm)

By default, subdirectory *biomaj* is mounted as the biomaj data in the container (/var/lib/biomaj). It expects to match the global.properties configuration (sub directories db, conf, process, ...)

Logs can be found in /var/log/biomaj in containers

To separate biomaj config/logs/... from data (downloaded data), use the docker-compose-otherdb.yml template.

Example .env when biomaj config and data are colocated (conf, log and data in same root directory) using docker-compose.yml

    BIOMAJ_DIR=/opt/biomaj-docker

Example .env when biomaj config and data are separated (docker-compose-otherdb.yml)

    BIOMAJ_DIR=/opt/biomaj-docker
    # in container, data directory will override global.properties data.dir and
    # store data in container directory /db
    BIOMAJ_DATA_DIR=/db
    # we want data to be saved in local host directory /db
    BIOMAJ_HOST_DATA_DIR=/db


# Proxy

Biomaj uses 2 proxy, a public one to use API (and biomaj-cli), exposing only some of the components, and an other one, for services communication.

*docker-compose.yml* is a setup that makes use of Traefik (https://traefik.io/) that makes use of service discovery to automatically route HTTP requests to biomaj micro services. Traefik also provides a visual dashboard to check for requests status (should not be expose on internet)


# Config

Container contains a default configuration. If you expect to override it, simply update files in biomaj-config directory and add volume to /etc/biomaj in container


# Debug

Execute a base image

    sudo docker run -it --rm --net biomajdocker_default -v /home/osallou/Development/NOSAVE/genouest/biomaj-docker/biomaj:/var/lib/biomaj/data -e "BIOMAJ_CONFIG=/etc/biomaj/config.yml" -e "REDIS_PREFIX=biomajdaemon" -e "RABBITMQ_USER=biomaj" -e "RABBITMQ_PASSWORD=biomaj" osallou/biomaj-docker /bin/bash

# Usage example

    osallou@tifenn~/Development/NOSAVE/genouest/biomaj-docker (develop) $ sudo docker-compose -f docker-compose.yml -f docker-compose-dev.yml up -d
    WARNING: The BIOMAJ_USER_PASSWORD variable is not set. Defaulting to a blank string.
    Creating network "biomajdocker_default" with the default driver
    Creating biomajdocker_biomaj-redis_1
    Creating biomajdocker_biomaj-elasticsearch_1
    Creating biomajdocker_biomaj-zipkin_1
    Creating biomajdocker_biomaj-consul_1
    Creating biomajdocker_biomaj-mongo_1
    Creating biomajdocker_biomaj-rabbitmq_1
    Creating biomajdocker_biomaj-public-proxy_1
    Creating biomajdocker_biomaj-prometheus_1
    Creating biomajdocker_biomaj-internal-proxy_1
    Creating biomajdocker_biomaj-download-message_1
    Creating biomajdocker_biomaj-process-web_1
    Creating biomajdocker_biomaj-user-web_1
    Creating biomajdocker_biomaj-process-message_1
    Creating biomajdocker_biomaj-download-web_1
    Creating biomajdocker_biomaj-daemon-message_1
    Creating biomajdocker_biomaj-daemon-web_1
    Creating biomajdocker_biomaj-watcher-web_1

To enable tracing, you need to launch zipkin server:

    sudo docker-compose -f docker-compose.yml -f docker-compose-dev.yml up -d

List containers

    osallou@tifenn~/Development/NOSAVE/genouest/biomaj-docker (develop) $ sudo docker ps
    CONTAINER ID        IMAGE                  COMMAND                  CREATED             STATUS              PORTS                                                                                                        NAMES
    7973eedb3719        osallou/biomaj-test    "/root/watcher.sh"       32 seconds ago      Up 31 seconds                                                                                                                    biomajdocker_biomaj-watcher-web_1
    1eb5236441f2        osallou/biomaj-test    "gunicorn -b 0.0.0.0:"   33 seconds ago      Up 31 seconds                                                                                                                    biomajdocker_biomaj-daemon-web_1
    049162452a9e        osallou/biomaj-test    "python3 /root/biomaj"   33 seconds ago      Up 32 seconds                                                                                                                    biomajdocker_biomaj-daemon-message_1
    8ff655a62704        osallou/biomaj-test    "gunicorn -b 0.0.0.0:"   36 seconds ago      Up 34 seconds                                                                                                                    biomajdocker_biomaj-download-web_1
    2db7a966d105        osallou/biomaj-test    "gunicorn -b 0.0.0.0:"   36 seconds ago      Up 34 seconds                                                                                                                    biomajdocker_biomaj-user-web_1
    3f6834d43520        osallou/biomaj-test    "python3 /root/biomaj"   36 seconds ago      Up 33 seconds                                                                                                                    biomajdocker_biomaj-process-message_1
    a741602148e2        osallou/biomaj-test    "gunicorn -b 0.0.0.0:"   36 seconds ago      Up 33 seconds                                                                                                                    biomajdocker_biomaj-process-web_1
    fd98d0e1c079        osallou/biomaj-test    "python3 /root/biomaj"   36 seconds ago      Up 34 seconds                                                                                                                    biomajdocker_biomaj-download-message_1
    91949869e05e        osallou/biomaj-proxy   "/nginx-template.sh"     36 seconds ago      Up 34 seconds       0.0.0.0:5080->80/tcp                                                                                         biomajdocker_biomaj-internal-proxy_1
    691b2ffd00a0        prom/prometheus        "/bin/prometheus -sto"   36 seconds ago      Up 33 seconds       0.0.0.0:9090->9090/tcp                                                                                       biomajdocker_biomaj-prometheus_1
    8a0b407581f7        osallou/biomaj-proxy   "/nginx-template.sh"     36 seconds ago      Up 34 seconds       0.0.0.0:5000->80/tcp                                                                                         biomajdocker_biomaj-public-proxy_1
    c50961e28f47        rabbitmq               "docker-entrypoint.sh"   52 seconds ago      Up 51 seconds       4369/tcp, 5671-5672/tcp, 25672/tcp                                                                           biomajdocker_biomaj-rabbitmq_1
    7d46a4951a28        mongo                  "/entrypoint.sh mongo"   52 seconds ago      Up 35 seconds       27017/tcp                                                                                                    biomajdocker_biomaj-mongo_1
    dcb880742472        progrium/consul        "/bin/start -server -"   52 seconds ago      Up 36 seconds       53/udp, 0.0.0.0:8400->8400/tcp, 8301-8302/udp, 8300-8302/tcp, 0.0.0.0:8500->8500/tcp, 0.0.0.0:8600->53/tcp   biomajdocker_biomaj-consul_1
    24b5806d84c1        openzipkin/zipkin      "/bin/sh -c 'test -n "   52 seconds ago      Up 51 seconds       9410/tcp, 0.0.0.0:9411->9411/tcp                                                                             biomajdocker_biomaj-zipkin_1
    3983693666eb        redis                  "/entrypoint.sh redis"   52 seconds ago      Up 50 seconds       6379/tcp                                                                                                     biomajdocker_biomaj-redis_1


To create a user, simply connect to biomaj-user container:

    sudo docker exec -it 2db7a966d105 /bin/bash
    # ....

# Use it

Use biomaj-cli executable from biomaj-cli package to execute update/removal against remote biomaj instance.
Proxy is biomaj-public-proxy, listening on port 5000 (using default docker-compose configuration)

Example:

    biomaj-cli.py --proxy http://biomaj-public-proxy --api-key XYZ --update --bank Anopheles_gambiae


# Local testing

For a simple test in a monolithic configuration (one container only)

    docker run --name biomaj-mongo -d mongo
    docker run -e "BIOMAJ_CONF=/etc/biomaj/global_local.properties" --rm -v local_path:/var/lib/biomaj --link biomaj-mongo:biomaj-mongo osallou/biomaj-docker biomaj-cli.py --help
    docker run -e "BIOMAJ_CONF=/etc/biomaj/global_local.properties" --rm -v local_path:/var/lib/biomaj --link biomaj-mongo:biomaj-mongo osallou/biomaj-docker biomaj-cli.py --update --bank alu
    docker run -e "BIOMAJ_CONF=/etc/biomaj/global_local.properties" --rm -v local_path:/var/lib/biomaj --link biomaj-mongo:biomaj-mongo osallou/biomaj-docker biomaj-cli.py --status

Logs are in /var/log/biomaj
Configuration files (bank properties) in /etc/biomaj/conf.d
Process scripts should be put in /etc/biomaj/process.d
Data files are put in /var/lib/biomaj
Lock files are in /var/run/biomaj

In production, those directories should be bind mounted and shared among all BioMAJ containers.

# biomaj-process and software

The biomaj image is a Debian based image. It contains no dedicated software but BioMAJ core resources.
If you need to execute specific software such a blast, diamond, anything... you need to create your own image.
You can create a new Docker image based on given Dockerfile or update existing one (if Debian based).
To do so, launch docker-compose images then

    docker exec -it BIOMAj_PROCESS_MESSAGE_CONTAINERID /bin/bash
    #xyz> apt-get update
    #xyz> apt-get install some-stuff
    #xyz> exit
    docker commit BIOMAj_PROCESS_MESSAGE_CONTAINERID
    docker tag BIOMAj_PROCESS_MESSAGE_CONTAINERID me/mybiomajcontainer

 Then update in docker-compose.yml the image name for biomaj-process-message with *me/mybiomajcontainer*

 You can stop and restart your containers and docker will use your new image for biomaj process management.

# watcher

Access to http://biomaj-public-proxy:5000/app/#/


# Influxdb

if Influxdb is used, database must be created first. To do so, connect in a container (any) and create database with curl:

    curl -X POST 'http://biomaj-influxdb:8086/db?u=root&p=root' \
      -d '{"name": "biomaj"}'

Grafana can be used to visualize statistics.

# Logging

Logging is defined in production.ini for web services and config.yml for others. You cna mount biomaj-config to /etc/biomaj to replace default configuration files and change log levels, handlers etc...

With python logging it is easy to setup centralized logging. In both config files, you can add for example the following with a Graylog server:


In config.yml, handlers section add:

        'gelf':
            'class': 'graypy.GELFUDPHandler'
            'host': 'graylog'
            'port':  12201
            'formatter': 'generic'
            'level': 'INFO'

Do the same in production.ini in INI logging format.

And in biomaj handler , after console and file, add gelf.
The docker image already has the graypy module installed for easy testing.


# Components

By default, elasticsearch and mail are disabled in configuration. Persistence is
managed in mongodb database and /var/lib/biomaj. The rest of the container can
be safely removed after usage.
