# Setup

## configmaps

Upload config maps, updating properties to match your needs

    kubectl create configmap biomaj-rabbitmq-config --from-file=rabbitmq.config
    kubectl create configmap biomaj-config --from-file=config.yml
    kubectl create configmap biomaj-global-properties --from-file=global.properties
    kubectl create configmap biomaj-traefik-config --from-file=traefik.toml
    kubectl create configmap biomaj-prometheus --from-file=prometheus.yml

## update persitent volumes

Update *-pv-volume.yml to match your persistent volumes then:

    kubectl apply -f biomaj-banks-pv-volume.yml
    kubectl apply -f biomaj-db-pv-volume.yml

Extra PV needed pv for databases persistence:

* biomaj-influxdb-pv-claim
* biomaj-mongodb-pv-claim
* biomaj-redis-pv-claim

## Deploy with helm

    helm package biomaj
    helm install biomaj-3.1.0.tar.gz