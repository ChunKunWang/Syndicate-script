#!/bin/bash
ADMIN_EMAIL="amos@cs.unc.edu"
ADMIN_CERTS="/home/amos/syndicate-docker/release/ms/admin.pem"
ADMIN_PEM="./admin.pem"

#Copy out admin certs from MS's container
cd /home/amos/syndicate-docker/release/ms
make copy_cert
cd /home/amos/Syndicate-script/DropBox

# Copy in admin certs
docker cp $ADMIN_CERTS ms:/home/syndicate/
docker cp $ADMIN_CERTS ag:/home/syndicate/
docker cp $ADMIN_CERTS rg:/home/syndicate/
docker cp $ADMIN_CERTS ug:/home/syndicate/

# Register syndicate tool
COMMAND="yes y | syndicate setup $ADMIN_EMAIL $ADMIN_PEM http://172.27.0.10:8080"
docker exec -ti ms /bin/bash -c "$COMMAND"

COMMAND="yes y | syndicate setup $ADMIN_EMAIL $ADMIN_PEM http://172.27.0.10:8080"
docker exec -ti ag /bin/bash -c "$COMMAND"

COMMAND="yes y | syndicate setup $ADMIN_EMAIL $ADMIN_PEM http://172.27.0.10:8080"
docker exec -ti rg /bin/bash -c "$COMMAND"

COMMAND="yes y | syndicate setup $ADMIN_EMAIL $ADMIN_PEM http://172.27.0.10:8080"
docker exec -ti ug /bin/bash -c "$COMMAND"

# Create volume
COMMAND="syndicate create_volume name=test-volume description=test blocksize=1048576 email=$ADMIN_EMAIL"
docker exec -ti ms /bin/bash -c "$COMMAND"

COMMAND="syndicate create_gateway email=$ADMIN_EMAIL volume=test-volume name=AG01 private_key=auto type=AG caps=ALL host=ag"
docker exec -ti ms /bin/bash -c "$COMMAND"

COMMAND="syndicate create_gateway email=$ADMIN_EMAIL volume=test-volume name=UG01 private_key=auto type=UG caps=ALL host=ug"
docker exec -ti ms /bin/bash -c "$COMMAND"

COMMAND="syndicate create_gateway email=$ADMIN_EMAIL volume=test-volume name=RG01 private_key=auto type=RG caps=ALL host=rg"
docker exec -ti ms /bin/bash -c "$COMMAND"

#Export cert from ms and copy to rg container
COMMAND="syndicate export_gateway RG01 ."
docker exec -ti ms /bin/bash -c "$COMMAND"
docker cp ms:/home/syndicate/RG01 .
docker cp RG01 rg:/home/syndicate/

#Export cert from ms and copy to rg container
COMMAND="syndicate export_gateway AG01 ."
docker exec -ti ms /bin/bash -c "$COMMAND"
docker cp ms:/home/syndicate/AG01 .
docker cp AG01 ag:/home/syndicate/

COMMAND="syndicate export_volume test-volume ."
docker exec -ti ms /bin/bash -c "$COMMAND"
docker cp ms:/home/syndicate/test-volume .
docker cp test-volume rg:/home/syndicate/
docker cp test-volume ag:/home/syndicate/

#Run import command in rg container
COMMAND="syndicate import_volume test-volume force"
docker exec -ti rg /bin/bash -c "$COMMAND"

COMMAND="syndicate import_gateway RG01 force"
docker exec -ti rg /bin/bash -c "$COMMAND"

#Run import command in ag container
COMMAND="syndicate import_volume test-volume force"
docker exec -ti ag /bin/bash -c "$COMMAND"

COMMAND="syndicate import_gateway AG01 force"
docker exec -ti ag /bin/bash -c "$COMMAND"


# PREPARE RG: local
echo "PREPARE RG-Local"
#Setup disk RG driver
#Src: https://github.com/syndicate-storage/syndicate-core/tree/master/python/syndicate/rg/drivers/disk
docker exec -ti rg /bin/bash -c "mkdir download"
docker cp ./rg-driver/config rg:/home/syndicate/download
docker cp ./rg-driver/secrets rg:/home/syndicate/download
docker cp ./rg-driver/driver rg:/home/syndicate/download

COMMAND_UPDATE_RG="syndicate update_gateway RG01 driver=/home/syndicate/download/"
COMMAND_START_RG="syndicate-rg -u amos@cs.unc.edu -v test-volume -g RG01 -d3"

if [[ `docker inspect -f {{.State.Running}} rg` = 'true' ]];
then
    docker exec -ti rg /bin/bash -c "$COMMAND_UPDATE_RG"
    #docker exec -ti rg /bin/bash -c "$COMMAND_START_RG"
fi
echo "End of Setup RG-Local"

# PREPARE iRODS-AG
echo "PREPARE AG-iRODS"
#Setup disk RG driver
#Src: 
docker exec -ti ag /bin/bash -c "mkdir download"
docker cp ./ag-driver/config ag:/home/syndicate/download
docker cp ./ag-driver/secrets ag:/home/syndicate/download
docker cp ./ag-driver/driver ag:/home/syndicate/download

COMMAND_UPDATE_AG="syndicate update_gateway AG01 driver=/home/syndicate/download/"
COMMAND_START_AG="syndicate-ag -u amos@cs.unc.edu -v test-volume -g AG01 -d3"

if [[ `docker inspect -f {{.State.Running}} ag` = 'true' ]];
then
    docker exec -ti ag /bin/bash -c "$COMMAND_UPDATE_AG"
    #docker exec -ti ag /bin/bash -c "$COMMAND_START_AG"
fi
echo "End of Setup AG-iRODS"

