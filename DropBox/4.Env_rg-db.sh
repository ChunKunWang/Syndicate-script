#!/bin/bash
COMMAND="sudo apt-get -y update"
docker exec -ti rg-db /bin/bash -c "$COMMAND"

COMMAND="sudo apt-get -y install git"
docker exec -ti rg-db /bin/bash -c "$COMMAND"

COMMAND="sudo apt-get -y install vim"
docker exec -ti rg-db /bin/bash -c "$COMMAND"

COMMAND="sudo apt-get -y install python-pip python-dev build-essential"
docker exec -ti rg-db /bin/bash -c "$COMMAND"

COMMAND="git clone https://github.com/ChunKunWang/syndicate-fs-driver.git"
docker exec -ti rg-db /bin/bash -c "$COMMAND"

COMMAND="sudo pip install dropbox"
docker exec -ti rg-db /bin/bash -c "$COMMAND"

COMMAND="sudo apt-get -y remove syndicate-fs-driver"
docker exec -ti rg-db /bin/bash -c "$COMMAND"

COMMAND="cd syndicate-fs-driver; sudo python setup.py install"
docker exec -ti rg-db /bin/bash -c "$COMMAND"

