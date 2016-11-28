#!/bin/bash

#create network
docker network create -d bridge Syndicate-Net

#start MS
docker run -d -t -i -p 8080:8080 -p 8000:8000 --name ms syndicate-ms 

#start iRODs
docker run -d -t -i -p 1237:1247 --name irods myirods/icat:4.1.3 password

COMMAND="sudo apt-get update"
docker exec -i irods /bin/bash -c "$COMMAND"

COMMAND="yes y | sudo apt-get install vim"
docker exec -i irods /bin/bash -c "$COMMAND"

