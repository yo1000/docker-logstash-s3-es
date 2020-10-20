#!/bin/bash

docker container stop filebeat
docker container stop logstash
docker container stop logstash1
docker container stop logstash2
docker container stop elasticsearch
docker container stop localstack

docker container rm filebeat
docker container rm logstash
docker container rm logstash1
docker container rm logstash2
docker container rm elasticsearch
docker container rm localstack

docker image rm logstash-s3-es_filebeat
docker image rm logstash-s3-es_logstash
docker image rm logstash-s3-es_logstash1
docker image rm logstash-s3-es_logstash2

docker volume rm logstash-s3-es_lsdata
