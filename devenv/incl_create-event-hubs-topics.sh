# please source, do not execute
# assumption: incl_init-vars.sh was sourced

for t in $ehkTopicsOfTypeA
do
    echo "creating topic $t"
    az eventhubs eventhub create -g $resourceGroupName \
        --namespace-name $ehknsName \
        --message-retention 1 \
        --partition-count 4 \
        --name $t
done
