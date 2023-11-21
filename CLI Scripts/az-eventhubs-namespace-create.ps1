Param([string]$Name, [string]$RGName, [string]$evhnsSku)

echo "Creating Event Hubs Namespace $Name........................"

az eventhubs namespace create `
	--name $Name `
	--resource-group $RGName `
	--sku $evhnsSku