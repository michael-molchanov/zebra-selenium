FROM selenium/standalone-firefox:latest

LABEL maintainer "Michael Molchanov <mmolchanov@adyax.com>"

USER root

COPY entry_point.sh /opt/bin/entry_point.sh
RUN chmod +x /opt/bin/entry_point.sh
