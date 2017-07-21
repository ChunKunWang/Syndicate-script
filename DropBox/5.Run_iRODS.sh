#!/bin/bash
NETWORK_NAME="syndicate-docker"

#start iRODs
docker run --net $NETWORK_NAME -d -ti -p 1237:1247 --name irods myirods/icat:4.1.3 password

COMMAND="sudo apt-get update"
docker exec -i irods /bin/bash -c "$COMMAND"

COMMAND="yes y | sudo apt-get install vim"
docker exec -i irods /bin/bash -c "$COMMAND"

# PREPARE iRODS
FILE_UPLOAD=`cat ../irods-file.txt`
cat ../iRODS-config | docker exec -i irods /bin/bash -c "iinit"
docker exec -i irods /bin/bash -c "cat /root/.irods/irods_environment.json"
docker exec -i irods /bin/bash -c "echo '$FILE_UPLOAD' | tee irods-file.txt"

docker exec -i irods /bin/bash -c "iput /irods-file.txt"
docker exec -i irods /bin/bash -c "ils"


