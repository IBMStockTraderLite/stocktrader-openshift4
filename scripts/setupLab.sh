#!/bin/bash
if test "$0" = "./setupLab.sh"
then
   echo "Script being run from correct folder"
else
   echo "Error: Must be run from folder where this script resides"
   exit 1
fi

usage () {
  echo "Usage:"
  echo "setupLab.sh URL_TO_SETUP_FILES  STUDENT_ID"
}

if [ "$#" -ne 2 ]
then
    usage
    exit 1
fi

echo "Validating URL to setup files ..."
urlregex='(https?)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]'
if [[ ! $1 =~ $urlregex ]]; then
   echo "Fatal error: URL to setup files is not a well formed URL. Ask your instucrtor for help"
   exit 1
fi

echo "Validating student id  ..."
sidregex='^user0[0-4][1-9]$|^user0[1-5]0$'
if [[ ! $2 =~ $sidregex ]]
then
   echo "Fatal error: $2 is not a valid student id. Ask your instructor for help"
   exit 1
fi

echo "Retrieving setup files ..."
http_code=`curl -o variables.sh -s -L -w "%{http_code}" $1 `
if [ $? -ne 0 ]
then
    echo "Error: Retrieving setup files. Check the URL and try again"
    exit 1
fi

if test  "$http_code" != "200"
then
  echo "Error: Retrieving setup files. HTTP code $http_code returned"
  exit 1
else
  chmod +x variables.sh
fi

echo "Getting application  subdomain for cluster  ..."
#ibmcloud ks cluster-get --cluster $CLUSTER_NAME > tmp.out

INTERNAL_REG_HOST=`oc get route docker-registry --template='{{ .spec.host }}' -n default`

if [ $? -ne 0 ]
then
    echo "Error: Retrieving application subdomain.  Redo cluster access setup and try again"
    exit 1
fi

SUBDOMAIN=${INTERNAL_REG_HOST:24}
PROJECT=`oc project -q`
ROUTEHOST="stocktrader-${PROJECT}.${SUBDOMAIN}"

echo "Updating OpenShift template with shared host for all routes: $ROUTEHOST"
sed -i"_x" "s/changeme/$ROUTEHOST/g" ../templates/stock-trader.yaml && rm ../templates/stock-trader.yaml_x

KAFKA_TOPIC=stocktrader-$2

echo "Using $KAFKA_TOPIC as Kafka topic name ..."

echo "Updating variables.sh with Kafka topic : $KAFKA_TOPIC"
sed -i"_x" "s/changeme/$KAFKA_TOPIC/g" variables.sh && rm variables.sh_x

echo "Setup completed successfully"
exit 0
