@description('Storage Account type')
@allowed([
  'Standard_LRS'
  'Standard_ZRS'
])
param storageAccountType string = 'Standard_LRS'

@description('Region')
@allowed([
  'westeurope'
  'northcentralus'
  'eastus2'
  'eastus2euap'
  'centralus'
  'canadaeast'
  'canadacentral'
  'northeurope'
  'australiaeast'
  'switzerlandnorth'
  'germanywestcentral'
  'eastasia'
  'francecentral'
])
param location string = 'westeurope'

@description('Storage Account Name')
param storageAccountName string

@description('Username of primary user')
param userName string

@description('Home directory of primary user. Should be a container.')
param homeDirectory string

@description('SSH Public Key for primary user.')
param publicKey string

resource storageAccountName_resource 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: storageAccountType
  }
  kind: 'StorageV2'
  properties: {
    isHnsEnabled: true
    isLocalUserEnabled: true
    isSftpEnabled: true
  }
}

resource storageAccountName_default_homeDirectory 'Microsoft.Storage/storageAccounts/blobServices/containers@2019-06-01' = {
  name: '${storageAccountName}/default/${homeDirectory}'
  properties: {
    publicAccess: 'None'
  }
  dependsOn: [
    storageAccountName_resource
  ]
}

resource storageAccountName_userName 'Microsoft.Storage/storageAccounts/localUsers@2019-06-01' = {
  parent: storageAccountName_resource
  name: '${userName}'
  properties: {
    permissionScopes: [
      {
        permissions: 'rcwdl'
        service: 'blob'
        resourceName: homeDirectory
      }
    ]
    homeDirectory: homeDirectory
    sshAuthorizedKeys: [
      {
        description: 'localuser public key'
        key: publicKey
      }
    ]
    hasSharedKey: false
  }
}

output defaultContainer string = homeDirectory
output user object = storageAccountName_userName.properties
output keys object = listKeys(storageAccountName_userName.id, '2019-06-01')
