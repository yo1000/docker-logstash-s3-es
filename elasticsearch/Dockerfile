FROM docker.elastic.co/elasticsearch/elasticsearch-oss:7.7.1

RUN elasticsearch-plugin install analysis-kuromoji

ENTRYPOINT ["docker-entrypoint.sh"]
