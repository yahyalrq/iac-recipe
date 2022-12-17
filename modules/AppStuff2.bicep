param location string = resourceGroup().location
param appServiceAppName string
param appServicePlanName string
param dbhost string
param dbuser string
param dbpass string
param dbname string
@allowed([
  'nonprod'
  'prod'
])
param environmentType string

var appServicePlanSkuName = (environmentType == 'prod') ? 'P2V3' : 'B1'

resource appServicePlan 'Microsoft.Web/serverFarms@2022-03-01' = {
  name: appServicePlanName
  kind: 'linux'
  properties: {
    reserved: true
  }

  location: location
  sku: {
    name: appServicePlanSkuName
  }
}
resource appServiceApp 'Microsoft.Web/sites@2022-03-01' = {
  name: appServiceAppName
  location: location
  kind: 'linux'
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    appSettings: [
      {
        name: 'DBUSER'
        value: dbuser
      }
      {
        name: 'DBPASS'
        value: dbpass
      }
      {
        name: 'DBNAME'
        value: dbname
      }
      {
        name: 'DBHOST'
        value: dbhost
      }
      {
        name: 'SCM_DO_BUILD_DURING_DEPLOYMENT'
        value: '1'
      }
    ]
  }
}

output appServiceAppHostName string = appServiceApp.properties.defaultHostName
