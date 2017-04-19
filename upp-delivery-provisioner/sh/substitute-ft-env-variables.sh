#!/bin/bash

for variable in `cat /tmp/ft-env-variables` ; do
    # this splits the key value pairs into two separate variables
    # for more info on how it works:
    # http://stackoverflow.com/a/19482947
    key=${variable%=*}
    value=${variable##*=}

    sed -i "s|\$${key}|${value}|g" /tmp/instance_user_data.yaml
done
