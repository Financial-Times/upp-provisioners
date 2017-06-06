#!/bin/bash

for variable in `cat /tmp/ft-env-variables` ; do
    # this splits the key value pairs into two separate variables
    # for more info on how it works:
    # https://unix.stackexchange.com/a/53315
    IFS='=' read -r key value <<< "$variable"

    sed -i "s|\$${key}|${value}|g" /tmp/persistent_instance_user_data.yaml
done
