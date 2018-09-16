#!/bin/bash

# required
: "${REQUESTS:?You must set the number of requests}"
: "${URL:?You must set the URL to test against}"
: "${UUID:?The UUID must be set}"

echo "STATUS_URI: ${STATUS_URI}"
echo "TEST_URI: ${URL}"

for i in $(seq "$REQUESTS"); do
  srun=`date +%s%N | cut -b1-13`
  echo "srun: ${srun}"
  response=$( curl --connect-timeout 5 -s -o /dev/null -w "%{http_code}" -L ${URL} )
  erun=`date +%s%N | cut -b1-13`
  echo "erun: ${erun}"
  diff=$((erun-srun))

  # post the response code back to opentsdb
  curl -s -X POST -o /dev/null -H "Content-Type: application/json" -d "{\"metric\": \"peak.response_code\",\"timestamp\":"${erun}",\"value\": \"${response}\",\"tags\": { \"test\": \"${UUID}\",\"node\": \"POD1\" }}" http://opentsdb:4242/api/put

  # post the response time to opentsdb
  curl -s -X POST -o /dev/null -H "Content-Type: application/json" -d "{\"metric\": \"peak.response_time\",\"timestamp\":"${erun}",\"value\": ${diff},\"tags\": { \"test\": \"${UUID}\",\"node\": \"POD1\" }}" http://opentsdb:4242/api/put

  # post the counter to opentsdb
  curl -s -X POST -o /dev/null -H "Content-Type: application/json" -d "{\"metric\": \"peak.counter\",\"timestamp\":"${erun}",\"value\": \"${i}\",\"tags\": { \"test\": \"${UUID}\",\"node\": \"POD1\" }}" http://opentsdb:4242/api/put

done
