using 'products.bicep'

var appname = readEnvironmentVariable('APP_NAME')
var appEnv = readEnvironmentVariable('APP_ENV')
var API_NAME = readEnvironmentVariable('API_NAME')
var API_VERSION = readEnvironmentVariable('API_VERSION')
var KEY_BACKEND_HOST = readEnvironmentVariable('KEY_BACKEND_HOST')
var activeNameWithoutQuotes = readEnvironmentVariable('activeNameWithoutQuotes')
var imageName = readEnvironmentVariable('imageName')


param apimServiceName = '${appname}apim${appEnv}'
param envrionmentName = '${appname}-appenv-${appEnv}'
param containerAppName = '${imageName}'
param productName = '${appname}-product'
param apiName = '${API_NAME}'
param backendHostKeyName = '${KEY_BACKEND_HOST}'
param activeRevisionName = '${activeNameWithoutQuotes}'

param apiVersionSetName = 'ComplianceAPI-VersionSet'
param apiVersionSetDescription = 'Version set for compliance API'
param apiDescription = 'API for ${appname}'
param apiRevisionDescription = 'Initial revision'
param apiRevision = '1'
param apiVersion = '${API_VERSION}'
param apiVersionDescription = 'This API version is in preview'
param terms = 'By using this API you agree to the terms of service'
