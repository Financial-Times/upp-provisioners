#!/bin/bash

OUTPUT="/tmp/output.txt"

echo "Happy Mondays!" > ${OUTPUT}
puppet --version >> ${OUTPUT}
git --version >> ${OUTPUT}
