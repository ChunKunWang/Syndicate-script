#!/bin/bash
syndicate update_gateway AG02 driver=/home/syndicate/download/

syndicate-ag -u amos@cs.unc.edu -v test-volume -g AG02 -d3

