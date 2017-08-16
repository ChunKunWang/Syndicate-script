Script to setup a demo for Syndicate and the development of Dropbox

Source code:

https://github.com/syndicate-storage/syndicate-fs-driver

https://github.com/syndicate-storage/syndicate-docker

https://github.com/syndicate-storage/syndicate-core


Environment requirment: Ubuntu 14.04

Description of files:
  - ag-driver and rg-driver:
      the config and secret files for `ag` and `rg` driver,
      where `ag` connects to iRODS; 
            `rg` connects to local file system

  - 1.Run_ms.sh, 
    2.Run_ag.sh,
    3.Run_ug.sh, 
    4.Run_rg.sh, 
    4.Run_rg-db.sh, 
    Run_iRODS.sh, 
    5.initial.sh, 
    Clr_containers.sh:
      demo scripts, see more explanation in the Demo section.
    

DropBox the directory of the Dropbox demo

Build docker images: 
In syndicate-docker/release/ms, type `make MS_APP_ADMIN_EMAIL=<email>`, Open up an webbrowser and access, `http://172.27.0.10:8000`. 

<Note: type `make` to restart MS>

Demo:

`1.Run_ms.sh` to setup MS.

`2.Run_ag.sh` to setup `ag` which connects to iRODS.

`3.Run_ug.sh` to setup `ug` for accessing syndicate-ug-tool.

`4.Run_rg.sh` to setup `rg` which connects to local file system.

`4.Run_rg-db.sh` to build `rg` with Dropbox driver.

`Run_iRODS.sh` run iRODS sever.

`5.initial.sh` to register and sync certs for all gateways

Clean the docker container: Run Clr_containers.sh



