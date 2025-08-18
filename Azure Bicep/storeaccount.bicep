/ Resource Group
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'resourceGroupName'
  location: 'westus'
}

// Storage Account
resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: 'storageaccountname'
  location: 'westus'
  sku: {
    name: 'Standard_GRS'
  }
  kind: 'StorageV2'
  dependsOn: [
    resourceGroup
  ]
}
