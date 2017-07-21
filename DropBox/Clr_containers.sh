#!/bin/bash

docker stop ms irods ug ag rg 

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

docker network rm syndicate-docker

