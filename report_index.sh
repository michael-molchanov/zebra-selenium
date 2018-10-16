#!/bin/bash

REPORT_PATH=$1

if [[ "$REPORT_PATH" == "" ]]; then
  exit 1
fi

[[ -f "$REPORT_PATH/index.html" ]] && rm "$REPORT_PATH/index.html"

cat /opt/report/header.html | tee -a "$REPORT_PATH/index.html"

for SUITE_FILE in $(find "$REPORT_PATH" -maxdepth 1 -iname *.html -type f | xargs -r -l basename); do
  if [[ "$SUITE_FILE" != "index.html" ]]; then
    SUITE_NAME=$(echo "$SUITE_FILE" | sed 's/^TEST\-//' | sed 's/\.html//')
    cat /opt/report/node.html | SUITE_FILE="$SUITE_FILE" SUITE_NAME="$SUITE_NAME" envsubst | tee -a "$REPORT_PATH/index.html"
  fi
done

cat /opt/report/footer.html | tee -a "$REPORT_PATH/index.html"

exit 0
