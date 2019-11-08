# this bash script is meant to be sourced (source ./incl_azlogin.sh rather than ./incl_azlogin.sh)

if [[ ! "$skipAzLogin" == "true" ]]
then
    #login to azure (should have no effect in the cloud shell which already is logged in)
    echo "login to Azure"
    az account show 1> /dev/null
    if [ $? != 0 ]
    then
        az login
    fi

    if [[ ! -z "$azureSubscription" ]]
    then
        az account set -s "$azureSubscription"
    fi

    # Show the Azure subscription that will be used
    echo "Azure subscription that will be used:"
    az account show --output table
else
    echo "skipping az login, and subscription selection, per configuration"
fi

