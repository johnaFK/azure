Param([string]$Location, [string]$RGName, [string]$StRedundancy)

echo "Creating Resource Group $RGName........................"

az group create `
	--location $Location `
	--name $RGName