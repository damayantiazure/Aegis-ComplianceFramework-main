#!/bin/bash
echo "Promote API script started..."
echo "============================"
echo "resource group name: $resourceGroupName"
echo "location: $location"
echo "app name: $APP_NAME"
echo "app environment: $APP_ENV"
echo "image name: $imageName"


# az config set extension.use_dynamic_install=yes_without_prompt
# az extension add -n containerapp

az containerapp ingress traffic set -n $imageName -g $resourceGroupName --revision-weight latest=100

./update-api.sh

json_output=$(az containerapp revision list -n $imageName -g $resourceGroupName --query "[?properties.trafficWeight == \`0\`].{name:name}")

# Iterate over each object in the JSON array and print the names
for row in $(echo "${json_output}" | jq -r '.[] | @base64'); do
    _jq() {
     echo ${row} | base64 --decode | jq -r ${1}
    }
    RevisionName=$(_jq '.name')
    echo "Deacrivating revision: $RevisionName"
    az containerapp revision deactivate -g $resourceGroupName  -n $imageName --revision $RevisionName
done

