FROM docker.elastic.co/logstash/logstash-oss:7.7.1

ENV LOGSTASH_HOME /opt/logstash
WORKDIR ${LOGSTASH_HOME}

RUN rm -f /usr/share/logstash/pipeline/logstash.conf
RUN bin/logstash-plugin install logstash-input-s3

ADD pipeline/ /usr/share/logstash/pipeline/
ADD config/ /usr/share/logstash/config/
ADD sincedb/ /usr/share/logstash/sincedb/

USER root
RUN touch /usr/share/logstash/sincedb/sincedb.txt
RUN chown logstash:root /usr/share/logstash/sincedb/sincedb.txt
RUN chmod 755 /usr/share/logstash/sincedb/sincedb.txt

USER logstash
