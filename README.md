# docker-logstash-s3-es
Sample of S3 and Elasticsearch integration using Logstash on Docker.


## How to Run

### Single logstash container
```
docker-compose up --build
```

### Multiple logstash containers (Horizontal scaling)
```
docker-compose -f docker-compose-loadbalance.yml up --build
```


## How to Stop

### Stop foreground containers
Press `Ctrl`+`C` key.

### Stop and Disposed related containers, images, volumes, networks
```
./clean.sh
docker volume prune
```


## How to Test
```
echo '
Create upload file
'
mkdir -p /tmp/logstash && \
echo '{"name":"ペリカン 万年筆 F 細字 緑縞 スーベレーン M400 正規輸入品", "brand":"Pelikan", "price":33440, "color":"緑 縞", "nib":"F 細字", "orthographic_variations":["Souverän","Souveran","スーベレーン"]}
{"name":"ペリカン 万年筆 EF 極細字 緑縞 スーベレーン M400 正規輸入品", "brand":"Pelikan", "price":33091, "color":"緑縞", "nib":"EF 極細字", "orthographic_variations":["Souverän","Souveran","スーベレーン"]}
{"name":"ペリカン 万年筆 F 細字 ホワイトトータス スーベレーン M400 正規輸入品", "brand":"Pelikan", "price":34883, "color":"ホワイトトータス", "nib":"F 細字", "orthographic_variations":["Souverän","Souveran","スーベレーン"]}
{"name":"ペリカン 万年筆 EF 極細字 ホワイトトータス スーベレーン M400 正規輸入品", "brand":"Pelikan", "price":33425, "color":"ホワイトトータス", "nib":"EF 極細字", "orthographic_variations":["Souverän","Souveran","スーベレーン"]}
{"name":"セーラー万年筆 万年筆 顔料ボトルインク ストーリア 20ml ライトブラウン 131006278", "brand":"セーラー万年筆", "price":1408, "color":"ライトブラウン", "ink":"超微粒子顔料インク", "content":"20ml", "orthographic_variations":["STORiA","ストーリア"]}
{"name":"セーラー万年筆 万年筆 顔料ボトルインク ストーリア 20ml ライトブラウン 131006278", "brand":"セーラー万年筆", "price":982, "color":"パープル", "ink":"超微粒子顔料インク", "content":"20ml", "orthographic_variations":["STORiA","ストーリア"]}
'>/tmp/logstash/testdata.json

echo '
Upload file to S3
'
ETH0_IP=$(ip a show dev eth0 | grep inet | grep -v inet6 | awk '{print $2}' | sed -e 's/\/[0-9]*//') && \
docker run \
    --rm -it \
    --add-host=localhost:${ETH0_IP} \
    -e AWS_ACCESS_KEY_ID=access_key_id_localstack \
    -e AWS_SECRET_ACCESS_KEY=secret_access_key_localstack \
    -e AWS_DEFAULT_REGION=ap-northeast-1 \
    -v /tmp/logstash:/tmp/logstash \
    amazon/aws-cli --endpoint-url=http://localhost:4566 \
    s3 cp /tmp/logstash/testdata.json s3://local-test/

echo '
Sleep 60s (Polling interval)
'
sleep 60s

echo '
Query to Elasticsearch
'
curl -XGET 'http://localhost:9200/local_test/_search?pretty=true'

curl -XGET -H 'Content-Type: application/json' 'http://localhost:9200/local_test/_search?pretty' -d'
{
  "query": {
    "match": {
      "orthographic_variations": "Souveran" 
    }
  }
}'
```

