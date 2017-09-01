#!/bin/bash
syndicate update_gateway RG02 driver=/home/syndicate/download/

syndicate-rg -u amos@cs.unc.edu -v test-volume -g RG02 -d3

