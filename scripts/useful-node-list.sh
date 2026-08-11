#!/bin/sh
exec openstack baremetal node list --long -c name -c uuid -c provision_state -c instance_uuid -c resource_class -c power_state -c maintenance
