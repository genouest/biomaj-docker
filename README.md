# Running

Execute docker-compose to launch all services.

you need to create a .env file in docker-composE.yml directory with:

    BIOMAJ_DIR=/..path_to.../biomaj-docker
    BIOMAJ_DATA_DIR=/..path_to_biomaj_root_dir  # Location of logs etc...
    BIOMAJ_USER_PASSWORD=biomaj_user_default_password
    DOCKER_URL=tcp://x.y.z:2375  # if you wish to execute processes in Docker containers, give the IP of the host where docker is running (or swarm)

By default, subdirectory *biomaj* is mounted as the biomaj data in the container (/var/lib/biomaj). It expects to match the global.properties configuration (sub directories db, conf, process, ...)

Logs can be found in /var/log/biomaj in containers

# Config

Container contains a default configuration. If you expect to override it, simply update files in biomaj-config directory and add volume to /etc/biomaj in container


# Debug

Execute a base image

    sudo docker run -it --rm --net biomajdocker_default -v /home/osallou/Development/NOSAVE/genouest/biomaj-docker/biomaj:/var/lib/biomaj/data -e "BIOMAJ_CONFIG=/etc/biomaj/config.yml" -e "REDIS_PREFIX=biomajdaemon" -e "RABBITMQ_USER=biomaj" -e "RABBITMQ_PASSWORD=biomaj" osallou/biomaj-test /bin/bash


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


# watcher

Access to http://biomaj-public-proxy:5000/app/#/

# Logging

Logging is defined in production.ini for web services and config.yml for others. You cna mount biomaj-config to /etc/biomaj to replace default configuration files and change log levels, handlers etc...

With python logging it is easy to setup centralized logging. In both config files, you can add for example the following with a Graylog server:


In config.yml, handlers section add:

        'gelf':
            'class': 'graypy.GELFHandler'
            'host': 'graylog'
            'port':  12201
            'formatter': 'generic'
            'level': 'INFO'

Do the same in production.ini in INI logging format.

And in biomaj handler , after console and file, add gelf.
The docker image already has the graypy module installed for easy testing.
