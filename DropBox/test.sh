#!/bin/bash
IMAGE_NAME="syndicate-docker-gateways"
NETWORK_NAME="syndicate-docker"

# set syndicate
docker run --net $NETWORK_NAME -ti --cap-add SYS_ADMIN --device /dev/fuse --privileged --name ag $IMAGE_NAME


