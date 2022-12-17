@sys.description('The Web App name.')
@minLength(3)
@maxLength(40)
param appServiceAppName1 string = 'ylaraqui-assignment-app-BE-bicep'
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
param storageAccountName string = 'ylaraquistorage'
@allowed([
  'nonprod'
  'prod'
])
param environmentType string
param location string = resourceGroup().location

@secure()
param dbhost string
@secure()
param dbuser string
@secure()
param dbpass string
@secure()
param dbname string

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

module appService1 'modules/AppStuff.bicep' = {
  name: 'appService1'
  params: {
    location: location
    appServiceAppName: appServiceAppName1
    appServicePlanName: appServicePlanName
    environmentType: environmentType
    dbhost: dbhost
    dbuser: dbuser
    dbpass: dbpass
    dbname: dbname
  }
}
module appService2 'modules/AppStuff2.bicep' = {
  name: 'appService2'
  params: {
    location: location
    appServiceAppName: appServiceAppName2
    appServicePlanName: appServicePlanName
    environmentType: environmentType
    dbhost: dbhost
    dbuser: dbuser
    dbpass: dbpass
    dbname: dbname
  }
}

output appServiceAppHostName1 string = appService1.outputs.appServiceAppHostName

output appServiceAppHostName2 string = appService2.outputs.appServiceAppHostName
