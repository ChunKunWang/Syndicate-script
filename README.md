Script to setup a demo for Syndicate

Source code:
1. https://github.com/syndicate-storage/syndicate-fs-driver
2. https://github.com/syndicate-storage/syndicate-docker
3. https://github.com/syndicate-storage/syndicate-core

Environment requirment:
Ubuntu 16.04

Description of files:
  - ag-config, ag-secrets, rg-config, rg-secrets:
      config and secret files for `ag` and `rg`

  - iRODS-config: 
      the iRODS setting used by Setup_gateways.sh

  - irods-file.txt: 
      the automcatically uploaded file to iRODS

  - Setup_MS_iRODS.sh, Setup_gateways.sh, Clr_containers.sh: 
      demo scripts, see more explanation in the Demo section

  - DropBox: 
      the directory of the Dropbox demo

Build docker images:
  In /syndicate-docker/devel/
  do `sudo make MS_APP_ADMIN_EMAIL=<mail>` 
  Add `172.17.0.2      ms` in the `/etc/hosts` 

Demo:
1. Run `./Setup_MS_iRODS.sh` to create containers for MS and iRODS

2. Run `./Setup_gateways.sh` to create and register `rg`, `ag` and `ug`

3. Run AG hosts in `ag` container,
   Command: `syndicate-ag -u <youremail> -v <volume> -g AG01 -d3`,
   ex: syndicate-ag -u amos@cs.unc.edu -v test-volume -g AG01 -d3

   Run RG hosts in `rg` container,
   Command: `syndicate-rg -u <youremail> -v <volume> -g RG01 -d3`,
   ex: syndicate-rg -u amos@cs.unc.edu -v test-volume -g RG01 -d3

4. Use syndicate-ug-tools under the directory, syndicate-ug-tools/build/bin, in `ug`, 
   ex: syndicate-ls -u <youremail> -v <volume> -g UG01 /

Clean the docker container:
Run `Clr_containers.sh`

