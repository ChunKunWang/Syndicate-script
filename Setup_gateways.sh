#!/bin/bash
ADMIN_EMAIL="amos@cs.unc.edu"
HOST_NAME="ms"
IRODS_NAME="irods"
ADMIN_PEM="./syndicate-core/ms/admin.pem"

# set syndicate
docker run -d -t -i -p 31111:31111 --name ag syndicate-gateways
docker run -d -t -i -p 31112:31112 --name ug syndicate-gateways
docker run -d -t -i -p 31113:31113 --name rg syndicate-gateways

docker network connect Syndicate-Net ms
docker network connect Syndicate-Net irods
docker network connect Syndicate-Net ag
docker network connect Syndicate-Net ug
docker network connect Syndicate-Net rg

COMMAND="yes y | syndicate setup $ADMIN_EMAIL $ADMIN_PEM http://ms:8080"
docker exec -ti ms /bin/bash -c "$COMMAND"

COMMAND="syndicate create_volume name=test-volume description=test blocksize=1048576 email=$ADMIN_EMAIL"
docker exec -ti ms /bin/bash -c "$COMMAND"

COMMAND="syndicate create_gateway email=$ADMIN_EMAIL volume=test-volume name=AG01 private_key=auto type=AG caps=ALL port=31111 host=ag"
docker exec -ti ms /bin/bash -c "$COMMAND"

COMMAND="syndicate create_gateway email=$ADMIN_EMAIL volume=test-volume name=UG01 private_key=auto type=UG caps=ALL port=31112 host=ug"
docker exec -ti ms /bin/bash -c "$COMMAND"

COMMAND="syndicate create_gateway email=$ADMIN_EMAIL volume=test-volume name=RG01 private_key=auto type=RG caps=ALL port=31113 host=rg"
docker exec -ti ms /bin/bash -c "$COMMAND"

COMMAND="tar zcvf cert.tar.gz .syndicate"
docker exec -ti ms /bin/bash -c "$COMMAND"

COMMAND="yes y | sudo apt-get install vim"
docker exec -i ug /bin/bash -c "$COMMAND"

docker cp ms:/home/syndicate/cert.tar.gz .

# COPY certificates
COPY_COMMAND="cat > /home/syndicate/cert.tar.gz"
UNCOMPRESS_COMMAND="tar zxvf cert.tar.gz"

if [[ `docker inspect -f {{.State.Running}} ag` = 'true' ]];
then
    cat cert.tar.gz | docker exec -i ag /bin/bash -c "$COPY_COMMAND"
    docker exec -i ag /bin/bash -c "$UNCOMPRESS_COMMAND"
fi

if [[ `docker inspect -f {{.State.Running}} ug` = 'true' ]];
then
    cat cert.tar.gz | docker exec -i ug /bin/bash -c "$COPY_COMMAND"
    docker exec -i ug /bin/bash -c "$UNCOMPRESS_COMMAND"
fi

if [[ `docker inspect -f {{.State.Running}} rg` = 'true' ]];
then
    cat cert.tar.gz | docker exec -i rg /bin/bash -c "$COPY_COMMAND"
    docker exec -i rg /bin/bash -c "$UNCOMPRESS_COMMAND"
fi

# PREPARE iRODS
FILE_UPLOAD=`cat ./irods-file.txt`
cat ./iRODS-config | docker exec -i irods /bin/bash -c "iinit"
docker exec -i irods /bin/bash -c "cat /root/.irods/irods_environment.json"
docker exec -i irods /bin/bash -c "echo '$FILE_UPLOAD' | tee irods-file.txt"

docker exec -i irods /bin/bash -c "iput /irods-file.txt"
docker exec -i irods /bin/bash -c "ils"

# PREPARE iRODS-AG
echo "PREPARE iRODS-AG"
AG_CONFIG=`cat ./ag-config`
AG_SECRETS=`cat ./ag-secrets`
COMMAND_UPDATE_AG="syndicate update_gateway AG01 driver=./syndicate-fs-driver/src/sgfsdriver/ag_driver"
COMMAND_START_AG="syndicate-ag -u amos@cs.unc.edu -v test-volume -g AG01 -d3"

if [[ `docker inspect -f {{.State.Running}} ag` = 'true' ]];
then
    COMMAND="echo '$AG_CONFIG' | sudo tee ~/syndicate-fs-driver/src/sgfsdriver/ag_driver/config"
    docker exec -ti ag /bin/bash -c "$COMMAND"

    COMMAND="echo '$AG_SECRETS' | sudo tee ~/syndicate-fs-driver/src/sgfsdriver/ag_driver/secrets"
    docker exec -ti ag /bin/bash -c "$COMMAND"
    
    docker exec -ti ag /bin/bash -c "$COMMAND_UPDATE_AG"
    #docker exec -ti ag /bin/bash -c "$COMMAND_START_AG"
fi
echo "End of Setup AG"

# PREPARE iRODS-RG
echo "PREPARE iRODS-RG"
RG_CONFIG=`cat ./rg-config`
RG_SECRETS=`cat ./rg-secrets`
COMMAND_UPDATE_RG="syndicate update_gateway RG01 driver=./syndicate-core/python/syndicate/rg/drivers/disk"
COMMAND_START_RG="syndicate-rg -u amos@cs.unc.edu -v test-volume -g RG01 -d3"

if [[ `docker inspect -f {{.State.Running}} rg` = 'true' ]];
then
    COMMAND="echo '$RG_CONFIG' | sudo tee ~/syndicate-core/python/syndicate/rg/drivers/disk/config"
    docker exec -ti rg /bin/bash -c "$COMMAND"

    COMMAND="echo '$RG_SECRETS' | sudo tee ~/syndicate-core/python/syndicate/rg/drivers/disk/secrets"
    docker exec -ti rg /bin/bash -c "$COMMAND"
    
    docker exec -ti rg /bin/bash -c "$COMMAND_UPDATE_RG"
    #docker exec -ti rg /bin/bash -c "$COMMAND_START_RG"
fi
echo "End of Setup RG"


