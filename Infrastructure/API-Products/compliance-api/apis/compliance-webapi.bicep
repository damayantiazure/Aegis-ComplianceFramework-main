
param apimServiceName string
param productName string
param apiName string
param backendHostKeyName string
param serviceUrl string
param apiVersion string
param apiVersionSetId string
param apiVersionDescription string
param apiRevision string
param apiRevisionDescription string
param description string
param displayName string

param isCurrent bool = true
param apiType string = 'http'

resource complianceWebApi 'Microsoft.ApiManagement/service/apis@2023-03-01-preview' = {
  name: '${apimServiceName}/${apiName}'  
  properties: {
    apiRevision: apiRevision
    apiRevisionDescription: apiRevisionDescription
    isCurrent: isCurrent
    apiType: apiType
    description: description
    displayName: displayName
    apiVersion: apiVersion
    apiVersionDescription: apiVersionDescription
    apiVersionSetId: apiVersionSetId
    format: 'openapi+json'
    value: loadTextContent('complianceapi-swagger.json')
    path: apiName
    subscriptionRequired: false
    serviceUrl: serviceUrl
  }
  
  resource policy 'policies@2023-03-01-preview' = {    
    name: 'policy'
    properties: {
      format: 'rawxml'
      value: replace(loadTextContent('../policies/common-api-policy.xml'), 'KEY_HOSTNAME', backendHostKeyName) 
    }
  }
}

resource complianceWebApiWithProduct 'Microsoft.ApiManagement/service/products/apis@2023-03-01-preview' = {
  name: '${apimServiceName}/${productName}/${apiName}'
  dependsOn: [
    complianceWebApi
  ]
}
