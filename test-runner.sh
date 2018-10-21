#!/bin/bash

# required
: "${REQUESTS:?You must set the number of requests}"
: "${URL:?You must set the URL to test against}"
: "${UUID:?The UUID must be set}"
: "${INFLUX_URL:?You must set the InfluxDB URL}"

echo "TEST_URI: ${URL}"

for i in $(seq "$REQUESTS"); do
  srun=`date +%s%N | cut -b1-13`
  response=$( curl --connect-timeout 5 -s -o /dev/null -w "%{http_code}" -L ${URL} )
  erun=`date +%s%N | cut -b1-13`
  diff=$((erun-srun))

  # post the response code back to influxdb
  curl -s -X POST -o /dev/null -d "response_code,uuid=${UUID} value=${response}" "${INFLUX_URL}/write?db=peakdb"

  # post the response time to influxdb
  curl -s -X POST -o /dev/null -d "response_time,test=${UUID} value=${diff}" "${INFLUX_URL}/write?db=peakdb"

done
