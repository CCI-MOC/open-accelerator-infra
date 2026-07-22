#!/bin/sh

openstack esi node list -f csv >esinodes.csv
sqlite3 -box :memory: -cmd '.import --csv esinodes.csv esinodes'
