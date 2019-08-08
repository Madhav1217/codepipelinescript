#!/bin/bash
aws configure set aws_access_key_id AKIAI2L5XM3WEEKX7EZA
aws configure set aws_secret_access_key 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
aws configure set default.region us-east-2
aws configure set output_format table
aws codepipeline start-pipeline-execution --name fristpipeline >> fristpipeline.log 2>&1
data=$(grep "pipelineExecutionId" fristpipeline.log)
pipelineid=$(echo "$data" | sed 's/.*| \(.*\)|/\1/')
rm -rf fristpipeline.log
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
