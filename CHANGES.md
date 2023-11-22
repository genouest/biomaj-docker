# Biomaj changes

Notes: requires mongo 3.x

## shahikorma

## v13 - 2022-04-28

* freeze gunicorn/gevent/greenlet which need specific version matches
* freeze pyyaml (need to be upgraded)
* freeze gunicorn (issues with python 3.7)
* freeze redis to 3.5.3, latest breaks stuff on debian buster
* freeze pymongo to 3.12.4 (v4 breaks some stuff)
* update biomaj to fix deprecated isalive (no impact in docker)

## v12 - 2022-03-02

* use biomaj 3.1.20

## v11 - 2022-03-02

* biomaj fixes, update components

## v9 - 2021-07-02

* biomaj fix (release detection)

## v8 - 2021-02-22

* Fix download (regexp use case)

## v7 - 2020-11-18

* update watcher for missing /bank endpoint

## v6 - 2020-11-12

* add /db endpoint to access via http to bank directories (listing/download)
  read-only access and authorization checks. For private banks access with
  basic authentication (login:apikey)
  If not willing to allow http access, set expose=false in global.properties,
  default is to expose public banks

## v5 - 2020-11-06

* enhancements in biomaj-download
* use miniconda for python 3

### v4 - 2020-07-21

* fixes on biomaj-download

### v3 - 2020-01-08

* fixes on biomaj-download
* add more logging on biomaj
* various enhancements in biomaj-download with curl options

### v2 - 2019-12-05

* fixes on biomaj

### v1 - 2019-05-03

* update biomaj-process with new docker .env var BIOMAJ_HOST_DATA_DIR
    Add example docker-compose-otherdb.yml to separate biomaj config directory and biomaj data directory
* update biomaj/biomaj-download/biomaj-core to support hard links (option in global.properties)
    if disk support hard links, avoid using file copies when copying data from previous releases or dependent banks

## vindaloo

### v4 - 2019-03-20

* update biomaj-download (fix to support spaces in remote files)

### v3 - 2019-03-19

* Change default log level
* update biomaj-cli and biomaj-daemon to get biomaj-data list and import

## massala

### v0 - 2018-11-22

* Add naming in versions
* Force pika library version 0.11.2 in biomaj-download and biomaj-process (latest not working)

