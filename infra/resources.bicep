param environmentName string
param location string = resourceGroup().location
param principalId string = ''

// The application frontend
//module web './app/web.bicep' = {
//  name: 'web'
//  params: {
//    environmentName: environmentName
//    location: location
//    applicationInsightsName: monitoring.outputs.applicationInsightsName
    //applicationInsightsName: ''
//    appServicePlanId: appServicePlan.outputs.appServicePlanId
//  }
//}

param serviceName string = 'web'
param appCommandLine string = ''
param applicationInsightsName string = ''
//param appServicePlanId string

module web './core/host/appservice-python.bicep' = {
  name: '${serviceName}-appservice-python-module'
  params: {
    environmentName: environmentName
    location: location
    serviceName: serviceName
    appCommandLine: appCommandLine
    applicationInsightsName: applicationInsightsName
    appServicePlanId: appServicePlan.outputs.appServicePlanId
  }
}

// Create an App Service Plan to group applications under the same payment plan and SKU
module appServicePlan './core/host/appserviceplan-sites.bicep' = {
  name: 'appserviceplan'
  params: {
    environmentName: environmentName
    location: location
  }
}

// Monitor application with Azure Monitor
//module monitoring './core/monitor/monitoring.bicep' = {
//  name: 'monitoring'
//  params: {
//    environmentName: environmentName
//    location: location
//  }
//}

//output APPLICATIONINSIGHTS_CONNECTION_STRING string = monitoring.outputs.applicationInsightsConnectionString
//output WEB_URI string = web.outputs.WEB_URI
output WEB_IDENTITY_PRINCIPAL_ID string = web.outputs.identityPrincipalId
output WEB_NAME string = web.outputs.name
output WEB_URI string = web.outputs.uri
