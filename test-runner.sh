#!/bin/bash

# required
: "${REQUESTS:?You must set the number of requests}"
: "${URL:?You must set the URL to test against}"
: "${STATUS_URI:?The status URI must be set}"
: "${UUID:?The UUID must be set}"

# update the status URI with the UUID
STATUS_URI="${STATUS_URI}/status/${UUID}"
echo "STATUS_URI: ${STATUS_URI}"
echo "TEST_URI: ${URL}"

# counters for resonse codes
ok=0
count=0
error=0
srun=`date +%s.%N`

for i in $(seq "$REQUESTS"); do
  response=$( curl --connect-timeout 5 -s -o /dev/null -w "%{http_code}" ${URL} )
  case $response in
    200)
      ok=$(( ok+1 ))
    ;;
    *)
      error=$(( error+1 ))
    ;;
  esac
  count=$(( count+1 ))
  if [ $(( $count % 100 )) -eq 0 ]; then
    echo "- $count requests processed"
    end=`date +%s.%N`
    drun=$(echo "$end - $srun" | bc -l)
    result=$(curl -s -X POST -o /dev/null -H "complete: 100" -H "ok: ${ok}" -H "duration: ${drun}" ${STATUS_URI})
    # reset 'ok' and 'error' values
    ok=0
    error=0
  fi
done
# print results
echo ":: Testing complete ::"
echo ":: Number of requests: ${REQUESTS}"
echo ":: Number of 200 codes: $ok"
echo ":: Number of errors: $error"
echo ":: Duration: $drun"
