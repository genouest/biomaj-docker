# Setup

## configmaps

Upload config maps, updating properties to match your needs

    kubectl create configmap biomaj-rabbitmq-config --from-file=rabbitmq.config
    kubectl create configmap biomaj-config --from-file=config.yml
    kubectl create configmap biomaj-global-properties --from-file=global.properties
    kubectl create configmap biomaj-traefik-config --from-file=traefik.toml

## update persitent volumes

Update *-pv-volume.yml to match your persistent volumes then:

    kubectl apply -f biomaj-banks-pv-volume.yml
    kubectl apply -f biomaj-db-pv-volume.yml

## Deploy with helm

    helm package biomaj
    helm install biomaj-3.1.0.tar.gz

## TODO

Add volume persistence for influxdb, redis and mongodb

If using existing mongo/redis/influx/rabbit deployments, update global.properties and config.yml to update connection info and do not deploy related deployments/services
