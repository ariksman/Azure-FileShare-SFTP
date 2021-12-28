# Create SFTP filesharing on Azure

## Create ssh keys

On OSX create ssh-keys
```PowerShell
ssh-keygen -t ed25519 
```

Copy to clipboard
```PowerShell
pbcopy < ~/.ssh/id_ed25519.pub
```

## Resource creation

If the feature is not registered, you must do so before proceeding:
```shell
# Check status
az feature show --namespace Microsoft.Storage --name AllowSFTP
# Register
az feature register --namespace Microsoft.Storage --name AllowSFTP 
```

Following commands do create the resource group and deploy `bicep` file. During the deployment, you will be asked for the storage-account name, user-name and ssh-key.

Create resource group and deploy:
```PowerShell
az group create --resource-group file-sharing-ne-dev-rg --locatio northeurope

az deployment group create \       
  --name deployFileSharing \  
  --resource-group file-sharing-ne-dev-rg \
  --template-file azureFileShare.bicep \
  --parameters location='northeurope'
```

Connect to file share
```PowerShell
sftp <storage_account_name>.<localuser_name>@<endpoint>
# E.g. sftp testaccount.user2@testaccount.blob.core.windows.net
```

Upload file
```PowerShell
sftp {user}@{host}:{remote_dir} <<< $'put {local_file_path}'
```

Download file
```PowerShell
sftp {user}@{host}:{remoteFileName} {localFileName}
```
