#!/bin/bash


main()
{
  local oses=(centos-6 centos-7 ubuntu-12 ubuntu-14)

  for os in ${oses[*]}
  do
    local image=irods-plugin-build:4.1.10-"$os"

    docker build --file dockerfiles/Dockerfile."$os" --tag "$image" .

    local src=scratch/"$os"

    cp --recursive --update irods_netcdf "$src"

    docker run --interactive --rm \
               --name=netcdf-builder \
               --user=$(id -u):$(id -g) \
               --volume=$(pwd)/"$src":/src \
               --volume=$(pwd)/packages:/packages \
               --volume=$(pwd)/scripts/build-packages.sh:/build-packages.sh \
               "$image" /build-packages.sh "$os"
  done

  # There are some bugs in the NetCDF build logic

  if [ -e packages/centos-7 ]
  then        
    for f in $(ls packages/centos-7/*centos6*.rpm 2> /dev/null)
    do
      mv "$f" "${f/centos6/centos7}"
    done
  fi

  if [ -e packages/ubuntu-12 ]
  then
    for f in $(ls packages/ubuntu-12/*0.deb)
    do
      mv "$f" "${f/.deb/-ubuntu12.deb}"
    done
  fi

  if [ -e packages/ubuntu-14 ]
  then
    for f in $(ls packages/ubuntu-14/*0.deb)
    do
      mv "$f" "${f/.deb/-ubuntu14.deb}"
    done
  fi
}


set -e

main
