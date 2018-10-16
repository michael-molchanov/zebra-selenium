#!/bin/bash

EXIT_CODE=0
export GEOMETRY="$SCREEN_WIDTH""x""$SCREEN_HEIGHT""x""$SCREEN_DEPTH"

function shutdown {
  kill -s SIGTERM $NODE_PID
  sleep 10
}

if [ ! -z "$SE_OPTS" ]; then
  echo "appending selenium options: ${SE_OPTS}"
fi

rm -f /tmp/.X*lock

xvfb-run -a --server-args="-screen 0 $GEOMETRY -ac +extension RANDR +extension DOUBLE-BUFFER +extension GLX +extension MIT-SHM" \
  java ${JAVA_OPTS} -jar /opt/selenium/selenium-server-standalone.jar \
  ${SE_OPTS} &
NODE_PID=$!

trap shutdown SIGTERM SIGINT

sleep 10

SUITE="$1"
java -jar /opt/selenese-runner/selenese-runner.jar --config "support/config" --baseurl "$SELENESE_BASE_URL" --driver remote --remote-url "http://127.0.0.1:4444/wd/hub" --remote-browser firefox "$SUITE"
EXIT_CODE=$?

/opt/bin/report_index.sh "$PWD/reports"

shutdown

exit $EXIT_CODE
