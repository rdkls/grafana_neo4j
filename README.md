## Graphite + Carbon + Statsd + Grafana + Neo4j templates

An all-in-one image running graphite and carbon-cache.

This image contains a sensible default configuration of graphite,
carbon-cache and grafana. Starting this container will expose following ports:

- `80`: the graphite web interface
- `3000`: the grafana web interface
- `2003`: the carbon-cache line receiver (the standard graphite protocol)
- `2004`: the carbon-cache pickle receiver
- `7002`: the carbon-cache query port (used by the web interface)
- `8125`: the statsd UDP port
- `8126`: the statsd management port


You can log into the administrative interface of graphite-web (a Django
application) with the username `admin` and password `admin`. These passwords can
be changed through the web interface.

**NB**: Please be aware that by default docker will make the exposed ports
accessible from anywhere if the host firewall is unconfigured.

### Data volumes

All data is stored in the /data folder in the container (graphite metrics and grafana db)

    docker run -it -v /data/graphite:/data \
               -e SECRET_KEY='random-secret-key' \
               -p 3000:3000 -p 2003:2003 iborojevic/grafana-neo4j

### Technical details

By default, this instance of carbon-cache uses the following retention periods
resulting in whisper files of approximately 2.5MiB.

    1m:8d,10m:31d,1h:1y,1h:5y

### Based off

https://github.com/SamSaffron/graphite_docker


