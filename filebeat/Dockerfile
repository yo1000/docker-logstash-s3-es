FROM docker.elastic.co/beats/filebeat:7.7.1

ADD filebeat.yml /usr/share/filebeat/filebeat.yml

USER root

# Add permission that extract certificate to trust-store.
RUN chown -R filebeat:filebeat /etc/pki/ca-trust/extracted
RUN chmod -R u+w /etc/pki/ca-trust/extracted

RUN chown root:filebeat /usr/share/filebeat/filebeat.yml
RUN chmod 644 /usr/share/filebeat/filebeat.yml

USER filebeat

