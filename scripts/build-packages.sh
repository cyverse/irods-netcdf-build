#!/bin/bash

readonly OS="$1"

mkdir --parents /packages/"$OS"

for pkg in api microservices icommands
do
  /src/"$pkg"/packaging/build.sh clean
  /src/"$pkg"/packaging/build.sh -r
  cp /src/"$pkg"/build/* /packages/"$OS"
done
