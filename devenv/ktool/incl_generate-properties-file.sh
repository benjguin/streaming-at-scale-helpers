# please source, do not execute

if [[ -z "propFile" ]]
then
    propFile=/tmp/ehk1.properties
fi

cat > $propFile << EOF
ssl.endpoint.identification.algorithm=https
sasl.mechanism=PLAIN
request.timeout.ms=20000
bootstrap.servers=${ehknsName}.servicebus.windows.net:9093
retry.backoff.ms=500

sasl.jaas.config=org.apache.kafka.common.security.plain.PlainLoginModule required \\
    username=\"\$ConnectionString\" \\
    password=\"${ehknsConnectionString}\";
 
security.protocol=SASL_SSL
EOF

echo "Will use the following properties:"
echo "--------------------------------"
cat $propFile
echo "--------------------------------"
