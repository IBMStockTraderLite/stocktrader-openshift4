#!/bin/bash
# Copyright [2018] IBM Corp. All Rights Reserved.
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.
source variables.sh

echo "Initializing MariaDB database ..."
initDDL=$(cat ../mariadb/initsql.txt)
mariadbPod=`oc  get pods --no-headers -o custom-columns=":metadata.name" --field-selector=status.phase==Running | grep ${MARIADB_SERVICE_NAME} | grep -v deploy`
if [ -z "$mariadbPod" ]
then
  echo "Fatal error: no MariaDB pod found. Exiting ..."
  exit 1
fi

echo "Found MariaDB pod $mariadbPod. Running script to initialize database"

oc exec -it $mariadbPod -- /opt/rh/rh-mariadb102/root/usr/bin/mysql -u root -e "$initDDL"
