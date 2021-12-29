# Create a fully managed SFTP filesharing service on Azure

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

# Using the service

## Command line
Upload file
```PowerShell
sftp {user}@{host}:{remote_dir} <<< $'put {local_file_path}'
```

Download file
```PowerShell
sftp {user}@{host}:{remoteFileName} {localFileName}
```
## Azure storage explorer

It is also possible to use azure storage explorer to view the created blob container.

## Costs

Cost are estimated for the north europe, are subject of changes:
```Csharp
howManyMessages = ( dataSize / messageSize );
howManyOperations = ( howManyMessages / 10000 );
Cost = howManyOperations * 0,0447€
```

| Description      |SFTP message size| SFTP message count   | EUR     |
| :--------------- |:---------------:| --------------------:| -------:|
| Write 1GB cost   | 100KB           | 10000                | 0,0447€ |
| Write 100GB cost | 100KB           | 1000000              | 4,47€   |
| Write 100GB cost | 256KB           | 390625               | 1,746€  |
| Read 1GB cost    | 100KB           | 10000                | 0.0036€ |
| Read 100GB cost  | 100KB           | 1000000              | 0.36€   |
| Read 100GB cost  | 256KB           | 390625               | 0,141€  |

## Links
https://docs.microsoft.com/en-us/azure/storage/blobs/secure-file-transfer-protocol-support
https://azure.microsoft.com/en-us/pricing/details/storage/blobs/
