#!/bin/bash
watchForSeconds=$1

echo watchForSeconds=$watchForSeconds
echo ehknsName=${ehknsName}
echo topic=$topic

propFile=/tmp/ehkconsumer.properties
source incl_generatePropertiesFile.sh

kafka-console-consumer --topic $topic --offset earliest --partition 0 --consumer.config $propFile --bootstrap-server ${ehknsName}.servicebus.windows.net:9093 &
kafka-console-consumer --topic $topic --offset earliest --partition 1 --consumer.config $propFile --bootstrap-server ${ehknsName}.servicebus.windows.net:9093 &
kafka-console-consumer --topic $topic --offset earliest --partition 2 --consumer.config $propFile --bootstrap-server ${ehknsName}.servicebus.windows.net:9093 &
kafka-console-consumer --topic $topic --offset earliest --partition 3 --consumer.config $propFile --bootstrap-server ${ehknsName}.servicebus.windows.net:9093 &

sleep $watchForSeconds

kill %1
kill %2
kill %3
kill %4
