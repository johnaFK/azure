Param([string]$Location, [string]$RGName)

echo "Creating Resource Group $RGName........................"

az group create `
	--location $Location `
	--name $RGName