param apimServiceName string
param backendHostKeyName string
param serviceUrl string
param productName string 
param apiName string 
param versionSetId string
param apiRevision string
param apiRevisionDescription string
param apiDescription string
param apiVersion string
param apiVersionDescription string
param terms string

resource complianceApiProduct 'Microsoft.ApiManagement/service/products@2023-03-01-preview' = {
  name: '${apimServiceName}/${productName}'
  properties: {
    displayName: apiDescription
    description: apiDescription
    terms: terms
    subscriptionRequired: false
    // approvalRequired: false
    // subscriptionsLimit: 1
    state: 'published'    
  }
}



module complianceWebApi 'apis/compliance-webapi.bicep' = {
  name: apiName
  dependsOn: [
    complianceApiProduct
  ]
  params: {
    apimServiceName: apimServiceName
    backendHostKeyName: backendHostKeyName
    productName: productName
    apiName: apiName    
    serviceUrl: serviceUrl
    apiRevision: apiRevision
    apiRevisionDescription: apiRevisionDescription
    isCurrent: true    
    description: apiDescription
    displayName: apiDescription
    apiVersion: apiVersion
    apiVersionDescription: apiVersionDescription
    apiVersionSetId: versionSetId
  }
}
