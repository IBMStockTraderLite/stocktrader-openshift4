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

echo "Creating Kubernetes secret for stocktrader to access Watson Tone Analyzer ..."
oc create secret generic watson --from-literal=apikey=$TONE_ANALYZER_APIKEY --from-literal=endpoint=$TONE_ANALYZER_ENDPOINT
if [ $? -eq 0 ]; then
    echo "Watson Tone Analyzer setup completed successfully"
else
    echo "Error creating k8s secret for stocktrader to access Watson Tone Analyzer"
fi
