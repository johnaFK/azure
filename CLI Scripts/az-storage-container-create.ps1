Param([string]$StorageContainertName, [string]$StorageAccountName)

echo "Creating Storage Container $StorageContainertName........................"

az storage container create `
	--name $StorageContainertName `
	--account-name $StorageAccountName