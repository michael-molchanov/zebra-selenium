# Builder.
FROM maven:3-jdk-8-alpine as builder

WORKDIR /opt/selenese-runner

RUN apk --update --no-cache add \
  bash \
  build-base \
  curl \
  git \
  tar \
  unzip \
  wget \
  && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/fimash/selenese-runner-java.git ./

RUN mvn -P package

# Selenium + Selenese.
FROM selenium/standalone-firefox:latest

LABEL maintainer "Michael Molchanov <mmolchanov@adyax.com>"

USER root

COPY --from=builder /opt/selenese-runner/target/selenese-runner.jar /opt/selenese-runner/

COPY entry_point.sh /opt/bin/entry_point.sh
RUN chmod +x /opt/bin/entry_point.sh
