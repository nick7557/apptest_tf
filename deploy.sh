#!/bin/sh -e

#Usage: CONTAINER_VERSION=docker_container_version [create|update]

# register task-definition
sed <td-tomcat.template -e "s,@VERSION@,$1,">TASKDEF.json
aws ecs register-task-definition --region us-west-1 --cli-input-json file://TASKDEF.json > REGISTERED_TASKDEF.json
TASKDEFINITION_ARN=$( < REGISTERED_TASKDEF.json jq .taskDefinition.taskDefinitionArn )

# create or update service
sed "s,@@TASKDEFINITION_ARN@@,$TASKDEFINITION_ARN," <service-$2-tomcat.json >SERVICEDEF.json
aws ecs $2-service --region us-west-1 --cli-input-json file://SERVICEDEF.json | tee SERVICE.json
