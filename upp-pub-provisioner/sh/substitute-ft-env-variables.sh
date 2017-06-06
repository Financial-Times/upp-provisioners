#!/bin/bash

while read variable ; do
    # this splits the key value pairs into two separate variables
    # for more info on how it works:
    # https://stackoverflow.com/a/1521498
    # https://unix.stackexchange.com/a/53315
    key=$(cut -d '=' -f 1 <<< "$variable")
    value=$(cut -d '=' -f 2- <<< "$variable")

    sed -i "s|'\$${key}'|'${value}'|g" /tmp/persistent_instance_user_data.yaml
done < /tmp/ft-env-variables
