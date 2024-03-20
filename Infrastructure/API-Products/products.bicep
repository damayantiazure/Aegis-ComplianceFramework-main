
param apimServiceName string
param envrionmentName string
param activeRevisionName string
param containerAppName string
param backendHostKeyName string
param productName string
param apiName string
param apiVersionSetName string
param apiVersionSetDescription string
param apiDescription string
param apiRevisionDescription string
param apiRevision string
param apiVersion string
param apiVersionDescription string
param terms string


resource environment 'Microsoft.App/managedEnvironments@2022-03-01' existing = {
  name: envrionmentName  
}

resource containerApp 'Microsoft.App/containerApps@2022-03-01' existing = {
  name: containerAppName  
}

resource apiManagementService 'Microsoft.ApiManagement/service@2023-03-01-preview' existing = {
  name: apimServiceName  
}


resource nameValueEntryForBackendHost 'Microsoft.ApiManagement/service/namedValues@2023-03-01-preview' = {
  name: backendHostKeyName
  parent: apiManagementService
  properties: {
    displayName: backendHostKeyName
    secret: false
    value: !empty(activeRevisionName) ? containerApp.properties.latestRevisionFqdn : containerApp.properties.configuration.ingress.fqdn
  }
  dependsOn: [
    containerApp
  ]
}

module complianceApiVersionSet 'compliance-api/versionSets/compliance-version-set.bicep' = {
  name: apiVersionSetName
  params: {
    name: apiVersionSetName
    apimServiceName: apimServiceName
    description: apiVersionSetDescription
    versionHeaderName: 'api-version'    
  }
  dependsOn: [
    apiManagementService
  ]
}


module complianceApiProduct 'compliance-api/compliance-product.bicep' = {
  name: productName
  params: {
    apimServiceName: apimServiceName
    productName: productName
    backendHostKeyName: backendHostKeyName
    apiName: apiName
    serviceUrl: 'https://${environment.properties.staticIp}/'
    versionSetId: complianceApiVersionSet.outputs.apiVersionSetId
    apiDescription: apiDescription
    apiRevisionDescription: apiRevisionDescription
    apiRevision: apiRevision
    apiVersion: apiVersion
    apiVersionDescription: apiVersionDescription
    terms: terms
  }
  dependsOn: [
    environment
    containerApp
  ]
}





output staticIp string = environment.properties.staticIp
output backendFqdn string = containerApp.properties.configuration.ingress.fqdn
