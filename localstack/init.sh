#!/bin/bash

echo '
========================================
  Run localstack INIT Script
========================================
'

echo 'aws configure list'
aws configure list

echo 'aws s3 mb'
aws --endpoint-url=http://localhost:4566 s3 mb s3://${LOCALSTACK_S3_BUCKET}

echo '
========================================
  Finished localstack INIT Script
========================================
'

