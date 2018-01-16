#!/bin/bash

set -x
set -o nounset
set -o errexit

MKDIR="mkdir -p"
USER="admin"

#Prepare environmnet
$MKDIR /export/{Backup,Instances,Data,Logs,Packages,servers}
/usr/sbin/useradd $USER

chown -R admin:admin /export
