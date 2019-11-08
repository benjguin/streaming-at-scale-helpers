# please source, do not execute
# assumption: incl_init-vars.sh was sourced

for t in $ehkTopicsOfTypeA
do
    echo "deleting topic $t"
    az eventhubs eventhub delete -g $resourceGroupName \
        --namespace-name $ehknsName \
        --name $t
done


