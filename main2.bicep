@sys.description('The Web App name.')
@minLength(3)
@maxLength(40)
param appServiceAppName1 string = 'ylaraqui-assignment-app-bicep'
@sys.description('The second Web App name.')
@minLength(3)
@maxLength(40)
param appServiceAppName2 string = 'ylaraqui-assignment-app-FE-bicep'
@sys.description('The App Service Plan name.')
@minLength(3)
@maxLength(40)
param appServicePlanName string = 'ylaraqui-assignment-ASP-bicep'
@sys.description('The Storage Account name.')
@minLength(3)
@maxLength(40)
param storageAccountName string = 'jseijasstorage'
@allowed([
  'nonprod'
  'prod'
])
param environmentType string
param location string = resourceGroup().location

var storageAccountSkuName = (environmentType == 'prod') ? 'Standard_GRS' : 'Standard_LRS'

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-05-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: storageAccountSkuName
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }
}

module appService1 'modules/appStuff2.bicep' = {
  name: 'appService1'
  params: {
    location: location
    appServiceAppName: appServiceAppName1
    appServicePlanName: appServicePlanName
    environmentType: environmentType

  }
}
module appService2 'modules/appStuff2.bicep' = {
  name: 'appService2'
  params: {
    location: location
    appServiceAppName: appServiceAppName2
    appServicePlanName: appServicePlanName
    environmentType: environmentType
  }
}

output appServiceAppHostName1 string = appService1.outputs.appServiceAppHostName

output appServiceAppHostName2 string = appService2.outputs.appServiceAppHostName
