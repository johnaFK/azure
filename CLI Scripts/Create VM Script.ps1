$ServiceName="drools"
$EnviromentName="test"
$Location="southcentralus" 
$LocationAbr="scus"
$ImageUrnAlias="CentOS"
$StorageType="Standard_LRS"
$OsDiskSize="64"
$Size="Standard_B1s"
$AuthType="ssh"
$AdminUserName="linadmin"
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
	
echo "----------------------------------------------------------"
echo "|                                                         |"
echo "|              Instalación de Docker en VM                |"
echo "|                       $VMName                           |"
echo "|                                                         |"
echo "----------------------------------------------------------"
	  

az vm extension set `
  --name customScript `
  --publisher Microsoft.Azure.Extensions `
  --protected-settings '{"commandToExecute": "./install-docker-on-linux.sh"}' `
  --resource-group $RGName `
  --settings '{"fileUris":["https://raw.githubusercontent.com/MicrosoftDocs/mslearn-welcome-to-azure/master/configure-nginx.sh"]}' `
  --version 2.1 `
  --vm-name $VMName 
  
  

#az account list-locations -o table     southcentralus
#az vm image list      az vm image list --all --query "[?offer=='CentOS']"