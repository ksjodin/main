param templateSpecName string = 'storageSpec'

param templateSpecVersionName string = '1.0'

@description('Location for all resources.')
param location string = resourceGroup().location

resource createTemplateSpec 'Microsoft.Resources/templateSpecs@2022-02-01' = {
  name: templateSpecName
  location: location
}

resource createTemplateSpecVersion 'Microsoft.Resources/templateSpecs/versions@2022-02-01' = {
  parent: createTemplateSpec
  name: templateSpecVersionName
  location: location
  properties: {
    mainTemplate: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      'contentVersion': '1.0.0.0'
      'metadata': {}
      'parameters': {
        'storageAccountType': {
          'type': 'string'
          'defaultValue': 'Standard_LRS'
          'metadata': {
            'description': 'Storage account type.'
          }
          'allowedValues': [
            'Premium_LRS'
            'Premium_ZRS'
            'Standard_GRS'
            'Standard_GZRS'
            'Standard_LRS'
            'Standard_RAGRS'
            'Standard_RAGZRS'
            'Standard_ZRS'
          ]
        }
        'location': {
          'type': 'string'
          'defaultValue': '[resourceGroup().location]'
          'metadata': {
            'description': 'Location for all resources.'
          }
        }
      }
      'variables': {
        'storageAccountName': '[format(\'{0}{1}\', \'storage\', uniqueString(resourceGroup().id))]'
      }
      'resources': [
        {
          'type': 'Microsoft.Storage/storageAccounts'
          'apiVersion': '2022-09-01'
          'name': '[variables(\'storageAccountName\')]'
          'location': '[parameters(\'location\')]'
          'sku': {
            'name': '[parameters(\'storageAccountType\')]'
          }
          'kind': 'StorageV2'
          'properties': {}
        }
      ]
      'outputs': {
        'storageAccountNameOutput': {
          'type': 'string'
          'value': '[variables(\'storageAccountName\')]'
        }
      }
    }
  }
}
