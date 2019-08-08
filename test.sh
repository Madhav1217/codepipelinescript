#!/bin/bash
aws codepipeline start-pipeline-execution --name firstpipeline >> firstpipeline.log 2>&1
data=$(grep "pipelineExecutionId" firstpipeline.log)
pipelineid=$(echo "$data" | sed 's/.*| \(.*\)|/\1/')
rm -rf firstpipeline.log
echo $pipelineid
while true
do
   aws codepipeline get-pipeline-execution --pipeline-name fristpipeline --pipeline-execution-id $pipelineid >> status_data.log 2>&1
   cat status_data.log
   status_value=$(grep "InProgress" status_data.log)
   echo $status_value
   if [ -z "$status_value" ]; then
        echo "successfully completed ->pipelineid: $pipelineid"
        echo $(grep "status" status_data.log)
        mv status_data.log bkstatus_data.log
        break

   fi
   sleep 60
   mv status_data.log bkstatus_data.log
done
