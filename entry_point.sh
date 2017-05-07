#!/bin/bash

source /opt/bin/functions.sh

export GEOMETRY="$SCREEN_WIDTH""x""$SCREEN_HEIGHT""x""$SCREEN_DEPTH"

function shutdown {
  kill -s SIGTERM $NODE_PID
  wait $NODE_PID
}

if [ ! -z "$SE_OPTS" ]; then
  echo "appending selenium options: ${SE_OPTS}"
fi

SERVERNUM=$(get_server_num)

rm -f /tmp/.X*lock

xvfb-run -n $SERVERNUM --server-args="-screen 0 $GEOMETRY -ac +extension RANDR +extension DOUBLE-BUFFER +extension GLX +extension MIT-SHM" \
  java ${JAVA_OPTS} -jar /opt/selenium/selenium-server-standalone.jar \
  ${SE_OPTS} &
NODE_PID=$!

trap shutdown SIGTERM SIGINT

sleep 10

for SUITE in "$@"
do
  find ./ -maxdepth 1 -iname "$SUITE" -type f | xargs java -jar support/selenese-runner.jar --config "support/config" --baseurl "$SELENESE_BASE_URL" --driver remote --remote-url "http://127.0.0.1:4444/wd/hub" --remote-browser firefox
done

shutdown
exit
