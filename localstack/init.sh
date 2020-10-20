#!/bin/bash

echo '
========================================
  Run localstack INIT Script
========================================
'

echo 'localstack activate services'
echo $SERVICES

echo 'aws configure list'
aws configure list

if [[ "${SERVICES}" =~ "s3" ]]; then
  echo 'aws s3 mb'
  aws --endpoint-url=https://localhost:4566 \
      --no-verify \
      s3 mb "s3://${LOCALSTACK_S3_BUCKET}"
fi

if [[ "${SERVICES}" =~ "sqs" ]]; then
  echo 'aws sqs create'
  aws --endpoint-url=https://localhost:4566 \
      --no-verify \
      sqs create-queue \
      --queue-name "${LOCALSTACK_SQS_QUEUE}" \
      --attributes "FifoQueue=true"

  echo 'aws sqs get attr'
  aws --endpoint-url=https://localhost:4566 \
      --no-verify \
      sqs get-queue-attributes \
      --queue-url "https://localhost:4566/queue/${LOCALSTACK_SQS_QUEUE}" \
      --attribute-names All
fi

if [[ "${SERVICES}" =~ "s3" && "${SERVICES}" =~ "sqs" ]]; then
  echo 'aws config bucket notification'
  aws --endpoint-url=https://localhost:4566 \
      --no-verify \
      s3api put-bucket-notification-configuration \
      --bucket ${LOCALSTACK_S3_BUCKET} \
      --notification-configuration '{
        "QueueConfigurations": [
          {
            "QueueArn": "arn:aws:sqs:elasticmq:000000000000:local-test.fifo",
            "Events": [
              "s3:ObjectCreated:*"
            ]
          }
        ]
      }'
fi

echo '
========================================
  Finished localstack INIT Script
========================================
'
