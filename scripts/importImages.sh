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
docker pull clouddragons/tradr:latest
docker pull clouddragons/stock-quote:latest
docker pull clouddragons/portfolio:latest
docker pull clouddragons/event-streams-consumer:latest
docker pull clouddragons/trade-history:latest
INTERNAL_REG_HOST=`oc get route docker-registry --template='{{ .spec.host }}' -n default`
docker tag clouddragons/trade-history $INTERNAL_REG_HOST/openshift/trade-history:latest
docker tag clouddragons/stock-quote $INTERNAL_REG_HOST/openshift/stock-quote:latest
docker tag clouddragons/event-streams-consumer $INTERNAL_REG_HOST/openshift/event-streams-consumer:latest
docker tag clouddragons/tradr $INTERNAL_REG_HOST/openshift/tradr:latest
docker tag clouddragons/portfolio $INTERNAL_REG_HOST/openshift/portfolio:latest
docker tag clouddragons/portfolio $INTERNAL_REG_HOST/openshift/portfolio:latest
docker push $INTERNAL_REG_HOST/openshift/trade-history:latest
docker push $INTERNAL_REG_HOST/openshift/stock-quote:latest
docker push $INTERNAL_REG_HOST/openshift/event-streams-consumer:latest
docker push $INTERNAL_REG_HOST/openshift/tradr:latest
docker push $INTERNAL_REG_HOST/openshift/portfolio:latest
