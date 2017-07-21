#!/bin/bash
ADMIN_CERTS="/home/amos/syndicate-docker/release/ms/admin.pem"
ADMIN_EMAIL="amos@cs.unc.edu"
ADMIN_PEM="./admin.pem"

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


#Setup disk RG driver
#Src: https://github.com/syndicate-storage/syndicate-core/tree/master/python/syndicate/rg/drivers/disk
docker exec -ti rg /bin/bash "mkdir download"
docker cp config rg:/home/syndicate/download
docker cp secrets rg:/home/syndicate/download
docker cp driver rg:/home/syndicate/download




