#!/bin/bash

if [[ -z "$SSH_AUTH_SOCK" ]] ; then
    eval `ssh-agent`
    ssh-add
fi
