FROM docker.elastic.co/logstash/logstash-oss:7.7.1

ENV LOGSTASH_HOME /opt/logstash
WORKDIR ${LOGSTASH_HOME}

RUN rm -f /usr/share/logstash/pipeline/logstash.conf \
  bin/logstash-plugin install logstash-input-s3

ADD pipeline/ /usr/share/logstash/pipeline/
ADD config/ /usr/share/logstash/config/
