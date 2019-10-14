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

echo "Creating Kubernetes secret for stocktrader to access API Connect ..."
oc create secret generic stockquote --from-literal=apicurl=$API_CONNECT_PROXY_URL --from-literal=url=$STOCK_QUOTE_URL --from-literal=iexurl=$IEX_URL
if [ $? -eq 0 ]; then
    echo "API Connect  setup completed successfully"
else
    echo "Error creating k8s secret for stocktrader to access API Connect"
fi
