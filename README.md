# Running

Run mongodb instance

    docker run --name biomaj-mongodb -d mongo

Run biomaj commands

    docker run --rm -v local_path:/var/lib/biomaj --link biomaj-mongodb:biomaj-mongodb --help

For data persistency, mount /var/lib/biomaj in container.
For custom configuration, mount your own global.properties in /etc/biomaj/global.properties
