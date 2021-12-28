# Create SFTP filesharing on Azure

## Create ssh keys

On OSX create ssh-keys
```
ssh-keygen -t ed25519 
```

Copy to clipboard
```
pbcopy < ~/.ssh/id_ed25519.pub
```

## Resource creation

Following commands do create the resource group and deploy `bicep` file:
```
# Create resource group if not exists
az group create \
  --name rg-bicep \
  --location westus

# Deploy 
az deployment group create \
  --name myStorageDeployment1 \
  --resource-group rg-bicep \
  --template-file main.bicep \
  --parameters @main.parameters.json \
  --parameters location='centralus'
```

Create resource group and deploy:
```
az group create --resource-group file-share-ne-dev-rg --locatio northeurope --parameters location='centralus'
```

Connect to file share
```
sftp <storage_account_name>.<localuser_name>@<endpoint>
# E.g. sftp testaccount.user2@testaccount.blob.core.windows.net
