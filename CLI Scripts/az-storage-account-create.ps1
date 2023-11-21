Param([string]$StorageAccountName, [string]$RGName, [string]$StorageAccountRedundancy)

echo "Creating Storage Account $StorageAccountName........................"

az storage account create `
	--name $StorageAccountName `
	--resource-group $RGName `
	--sku $StorageAccountRedundancy

echo "Complete Storage Account $StorageAccountName........................"