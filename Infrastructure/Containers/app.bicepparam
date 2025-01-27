using 'app.bicep'


var appname = readEnvironmentVariable('APP_NAME')
var appEnv = readEnvironmentVariable('APP_ENV')
var tag = readEnvironmentVariable('tag')
var image = readEnvironmentVariable('imageName')
var activeNameWithoutQuotes = readEnvironmentVariable('activeNameWithoutQuotes')

param uamiName = '${appname}-uami-${appEnv}'
param containerRegistryName = '${appname}contregistry${appEnv}'
param acaEnvName = '${appname}-appenv-${appEnv}'
param tagName = '${tag}'
param imageName = '${image}'
param appInsightName = '${appname}-appinsights-${appEnv}'
param containerPort = 8080
param activeRevisionName = '${activeNameWithoutQuotes}'


