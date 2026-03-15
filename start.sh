#!/bin/sh

set -exuo pipefail

useradd -d ${CONTAINER_WORKSPACE} -u $USER_ID -g 0 $USER
chown -R $USER ${CONTAINER_WORKSPACE}
su -c "jupyter notebook --ip=0.0.0.0 --no-browser" $USER
