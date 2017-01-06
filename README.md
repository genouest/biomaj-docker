# Running

Run mongodb instance

    docker run --name biomaj-mongodb -d mongo

Run biomaj commands

    docker run --rm -v local_path:/var/lib/biomaj --link biomaj-mongodb:biomaj-mongodb osallou/biomaj-docker --help

For data persistency, mount /var/lib/biomaj in container.
For custom configuration, mount your own global.properties in /etc/biomaj/global.properties

By default, elasticsearch and mail are disabled in configuration. Persistency is
managed in mongodb database and /var/lib/biomaj. The rest of the container can
be safely removed after usage.

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
