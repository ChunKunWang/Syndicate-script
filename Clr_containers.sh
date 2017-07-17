#!/bin/bash

docker stop ms irods ug ag rg rg-db

if [[ `docker inspect -f {{.State.Running}} ms` = 'false' ]];
then
    docker rm ms
fi

if [[ `docker inspect -f {{.State.Running}} irods` = 'false' ]];
then
    docker rm irods
fi

if [[ `docker inspect -f {{.State.Running}} ug` = 'false' ]];
then
    docker rm ug
fi

if [[ `docker inspect -f {{.State.Running}} ag` = 'false' ]];
then
    docker rm ag
fi

if [[ `docker inspect -f {{.State.Running}} rg` = 'false' ]];
then
    docker rm rg
fi

if [[ `docker inspect -f {{.State.Running}} rg-db` = 'false' ]];
then
    docker rm rg-db
fi

docker network rm Syndicate-Net

