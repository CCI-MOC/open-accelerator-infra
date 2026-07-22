#!/bin/bash

attr=id
if [[ $1 == "-n" ]]; then
  attr=node_name
  shift
fi

tofu output -json | jq ".\"$1-nodes\".value[].$attr" -r
