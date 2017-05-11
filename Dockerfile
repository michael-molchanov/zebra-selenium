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

COPY index.html src/main/resources/jp/vmi/html/result/index.html
COPY result.html src/main/resources/jp/vmi/html/result/result.html

RUN mvn -P package

# Selenium + Selenese.
FROM selenium/standalone-firefox:latest

LABEL maintainer "Michael Molchanov <mmolchanov@adyax.com>"

USER root

RUN apt-get update -qqy \
  && apt-get -qqy --no-install-recommends install gettext-base \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/*

COPY --from=builder /opt/selenese-runner/target/selenese-runner.jar /opt/selenese-runner/

COPY entry_point.sh /opt/bin/entry_point.sh
RUN chmod +x /opt/bin/entry_point.sh

COPY report_index.sh /opt/bin/report_index.sh
RUN chmod +x /opt/bin/report_index.sh

COPY header.html /opt/report/header.html
COPY node.html /opt/report/node.html
COPY footer.html /opt/report/footer.html
