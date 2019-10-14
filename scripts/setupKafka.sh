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

echo "Deploying Kafka DNS proxy ..."

cat <<EOF | oc create -f -
kind: Service
apiVersion: v1
metadata:
  name: $KAFKA_SERVICE_NAME
spec:
  type: ExternalName
  externalName: $KAFKA_BROKER1_DNS
EOF

if [ $? -eq 0 ]; then
   echo "Creating Kubernetes secret for stocktrader to access Kafka ..."
   oc create secret generic kafka --from-literal=apikey=$KAFKA_API_KEY --from-literal=topic=$KAFKA_TOPIC_NAME --from-literal=broker1host=$KAFKA_BROKER1_DNS --from-literal=broker1port=$KAFKA_BROKER1_PORT
   if [ $? -eq 0 ]; then
      echo "Kafka DNS proxy setup completed successfully"
   else
      echo "Error creating k8s secret for stocktrader to access Kafka"
   fi
else
  echo "Error creating Kafka DNS proxy service  - exiting script"
fi
