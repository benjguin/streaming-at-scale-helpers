#!/bin/bash

echo ehknsName=${ehknsName}
echo topic=$topic

propFile=/tmp/ehkproducer.properties
source incl_generate-properties-file.sh

kafka-console-producer \
    --topic $topic \
    --broker-list ${ehknsName}.servicebus.windows.net:9093 \
    --producer.config $propFile
