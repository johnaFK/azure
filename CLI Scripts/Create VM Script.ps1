$ServiceName="drools"
$EnviromentName="test"
$Location="southcentralus" 
$LocationAbr="scus"
$ImageUrnAlias="CentOS"
$StorageType="Standard_LRS"
$OsDiskSize="64"
$Size="Standard_B2s"
$AuthType="ssh"
$AdminUserName="linadmin"
$AdminPassword="abcDEF1029;1"
$SshPublicKey="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDQl+aQ/wEjfcFO6GU2f7vWQHbgkSnZiDqIaRoJYSgxR71bXc5TTCfwlBamfl3Y930a6e6VPT/MYEM+gc4qfnulHMGmFOfrDr4qh3yItBa1zC0ZeRluYvYYs7Ujt/qS2rf/ZfxE3R+VAwKVYE+8dMeiEfiY5fPtdxo8cTA3O9f/rvNFf1H+anshNpJ6BR4Dnz4w7Phm5r+zJDkbuIz9+qTQcD3Yin95fmBptv9FK1KvhdVsA9F+ApsyWrC9BYBOWpK3Ee+/OxejlBwjUyh3Z5pc52sFz0H1VyytQzph2xXmcCCxfR9tyg3m4S0q9EdRWsu62hsdZAsZI6vN8lOztk6jC9JQCWw1bn9ocfTghoE7cM4nmZWiy5AZEtDyZVmDjDOJ2Xd1plg/z1f/HNAyEXnmT32vEy0KkUvNntRiarlFOBtSj+K1pBbn5IodKeVk8FdJsmiWArwFoW7N012zTXScCOGzQrxizgZPKZSTo/B5YjZz5FRIgucijEgbneYUFVPZwL2sZNSIB4qfWH8gwiSLGNukMusGsSitR2E9HUu+etWg1Ab+7fVH3B3ci9+M93Jxz7EGHDuruJ6kAZtcLSqIYdm/S580gNcXvpxl7HtbikVp6exss5FmIFhz6+NadFjRzz+8hBUtJ5s+RL6ygcCcLspMh2edEUsV8/RMjJftbQ== hdi`430007270@H37392LCOLEO"

$RGName="$ServiceName-$EnviromentName-rg"
$VMName="$EnviromentName-$ServiceName-$LocationAbr"
$NSGname="$VMName" + "NSG"

echo "----------------------------------------------------------"
echo "|                                                         |"
echo "|         Creando grupo de recursos $RGName               |"
echo "|                                                         |"
echo "----------------------------------------------------------"

az group create `
	--location $Location `
	--name $RGName
	
$RGid =$(az group list --query "[?name=='drools-test-rg'].[id]" --output tsv)

echo "----------------------------------------------------------"
echo "|                                                         |"
echo "|           Creando Maquina Virtual $VMName               |"
echo "|                                                         |"
echo "----------------------------------------------------------"

az vm create `
	--name $VMName `
	--resource-group $RGName `
	--location $Location `
	--image $ImageUrnAlias `
	--size $Size `
	--authentication-type  $AuthType `
	--admin-username $AdminUserName `
	--ssh-key-values $SshPublicKey `
	--storage-sku $StorageType `
	--os-disk-size-gb $OsDiskSize
  #--admin-password $AdminPassword `
	
echo "----------------------------------------------------------"
echo "|                                                         |"
echo "|        Actualizando Grupo de Seguridad de Red           |"
echo "|                       $NSGname                          |"
echo "|                                                         |"
echo "----------------------------------------------------------"

az network nsg rule create `
  --resource-group $RGName `
  --nsg-name $NSGname `
  --name allow-http `
  --protocol tcp `
  --priority 100 `
  --destination-port-ranges 80 `
  --access Allow

az network nsg rule create `
  --resource-group $RGName `
  --nsg-name $NSGname `
  --name allow-http-drools-business-central `
  --protocol tcp `
  --priority 101 `
  --destination-port-ranges 8080 `
  --access Allow

az network nsg rule create `
  --resource-group $RGName `
  --nsg-name $NSGname `
  --name allow-http-drools `
  --protocol tcp `
  --priority 102 `
  --destination-port-ranges 8001 `
  --access Allow

az network nsg rule create `
  --resource-group $RGName `
  --nsg-name $NSGname `
  --name allow-http-kie-server `
  --protocol tcp `
  --priority 103 `
  --destination-port-ranges 8180 `
  --access Allow
	
echo "----------------------------------------------------------"
echo "|                                                         |"
echo "|              Instalacion de Docker en VM                |"
echo "|                       $VMName                           |"
echo "|                                                         |"
echo "----------------------------------------------------------"
	  
az vm extension set `
  --name customScript `
  --publisher Microsoft.Azure.Extensions `
  --resource-group $RGName `
  --settings '{\"fileUris\":[\"https://raw.githubusercontent.com/johnaFK/azure/CLI-Scripts/CLI%20Scripts/install-docker-on-linux.sh\"], \"commandToExecute\": \"./install-docker-on-linux.sh\"}' `
  --vm-name $VMName 
	
echo "----------------------------------------------------------"
echo "|                                                         |"
echo "|              Instalacion de Drools en VM                |"
echo "|                       $VMName                           |"
echo "|                                                         |"
echo "----------------------------------------------------------"
	  
az vm extension set `
  --name customScript `
  --publisher Microsoft.Azure.Extensions `
  --resource-group $RGName `
  --settings '{\"fileUris\":[\"https://raw.githubusercontent.com/johnaFK/azure/CLI-Scripts/CLI%20Scripts/install-drools-on-linux.sh\"], \"commandToExecute\": \"./install-drools-on-linux.sh\"}' `
  --vm-name $VMName 


echo "The creation of the VM with drools has finished."

$VMpublicIp = $(az vm show -d --name $VMName --resource-group $RGName --query "publicIps" -o tsv)

echo "The public IP for the VM is: $VMpublicIp"

echo "Access to the Drools Busines Central: http://$VMpublicIp:8080/business-central/"

echo "Access to the Kie Server: http://$VMpublicIp:8180/kie-server"

echo "Access to the REST API Service: http://$VMpublicIp:8180/kie-server/services/rest/server/"
  #az account list-locations -o table     southcentralus
#az vm image list      az vm image list --all --query "[?offer=='CentOS']"