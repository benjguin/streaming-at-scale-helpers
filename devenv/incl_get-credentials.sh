# this script is meant to be executed thru source. e.g. source myscript.sh, rather than ./myscript.sh

# pre-requisites
# setup.sh must have successfully run before calling this piece of code
#
# please first source the following scripts before:
# - incl_initvars.sh
# - incl_azlogin.sh

echo "getting credentials and other variables from the environment"
if [[ -z "$credentialsAndOtherVarsRetrieved" ]]
then
    storageKey="`az storage account keys list -g $resourceGroupName --account-name $storageName --output tsv --query '[0].value' 2> /dev/null`"
    ehknsKey=`az eventhubs namespace authorization-rule keys list -g $resourceGroupName --namespace-name $ehknsName --name "RootManageSharedAccessKey" --query "primaryKey" --output tsv 2> /dev/null`
    ehknsConnectionString=`az eventhubs namespace authorization-rule keys list -g $resourceGroupName --namespace-name $ehknsName --name "RootManageSharedAccessKey" --query "primaryConnectionString" --output tsv 2> /dev/null`

    credentialsAndOtherVarsRetrieved=true
    echo "... variables retrieved"
else
    echo "... kept variables already available"
fi
