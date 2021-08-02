Param([string]$Location, [string]$RGName)

echo "----------------------------------------------------------"
echo "|                                                         |"
echo "|         Creando grupo de recursos $RGName               |"
echo "|                                                         |"
echo "----------------------------------------------------------"

az group create `
	--location $Location `
	--name $RGName