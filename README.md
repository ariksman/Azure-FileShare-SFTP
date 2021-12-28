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

If the feature is not registered, you must do so before proceeding:
```
// Check status
az feature show --namespace Microsoft.Storage --name AllowSFTP
// Register
az feature register --namespace Microsoft.Storage --name AllowSFTP 


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
az group create --resource-group file-sharing-ne-dev-rg --locatio northeurope

az deployment group create \       
  --name deployFileSharing \  
  --resource-group file-sharing-ne-dev-rg \
  --template-file azureFileShare.bicep \
  --parameters location='northeurope'
```

Connect to file share
```
sftp <storage_account_name>.<localuser_name>@<endpoint>
# E.g. sftp testaccount.user2@testaccount.blob.core.windows.net
```

Upload file
```
sftp {user}@{host}:{remote_dir} <<< $'put {local_file_path}'
```

Download file
```
sftp {user}@{host}:{remoteFileName} {localFileName}
```
