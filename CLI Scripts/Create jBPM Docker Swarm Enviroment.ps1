param(
  # Example $ServiceName = "jbpm-service"
  [Parameter(Mandatory, HelpMessage="The name of the service")]
  $ServiceName,

  # Example $EnviromentName="test"
  [Parameter(Mandatory)]
  $EnviromentName,

  # Example $TotalNodes="3"
  [Parameter(Mandatory, HelpMessage="The number of docker swarm nodes")]
  $TotalNodes,

  $Location="southcentralus", 
  $LocationAbr="scus",
  $ImageUrnAlias="CentOS",
  $StorageType="Standard_LRS",
  $OsDiskSize="64",
  $Size="Standard_B2s",
  $AuthType="ssh",
  $AdminUserName="linadmin",
  $AdminPassword="abcDEF1029;1",
  $SshPublicKey="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDQl+aQ/wEjfcFO6GU2f7vWQHbgkSnZiDqIaRoJYSgxR71bXc5TTCfwlBamfl3Y930a6e6VPT/MYEM+gc4qfnulHMGmFOfrDr4qh3yItBa1zC0ZeRluYvYYs7Ujt/qS2rf/ZfxE3R+VAwKVYE+8dMeiEfiY5fPtdxo8cTA3O9f/rvNFf1H+anshNpJ6BR4Dnz4w7Phm5r+zJDkbuIz9+qTQcD3Yin95fmBptv9FK1KvhdVsA9F+ApsyWrC9BYBOWpK3Ee+/OxejlBwjUyh3Z5pc52sFz0H1VyytQzph2xXmcCCxfR9tyg3m4S0q9EdRWsu62hsdZAsZI6vN8lOztk6jC9JQCWw1bn9ocfTghoE7cM4nmZWiy5AZEtDyZVmDjDOJ2Xd1plg/z1f/HNAyEXnmT32vEy0KkUvNntRiarlFOBtSj+K1pBbn5IodKeVk8FdJsmiWArwFoW7N012zTXScCOGzQrxizgZPKZSTo/B5YjZz5FRIgucijEgbneYUFVPZwL2sZNSIB4qfWH8gwiSLGNukMusGsSitR2E9HUu+etWg1Ab+7fVH3B3ci9+M93Jxz7EGHDuruJ6kAZtcLSqIYdm/S580gNcXvpxl7HtbikVp6exss5FmIFhz6+NadFjRzz+8hBUtJ5s+RL6ygcCcLspMh2edEUsV8/RMjJftbQ== hdi`430007270@H37392LCOLEO" 
)

$RGName="$ServiceName-$EnviromentName-rg"
$VMName="$EnviromentName-$ServiceName-$LocationAbr"

#         Creando grupo de recursos $RGName               
echo "Creating Resource Group $RGName in $Location........................"
az group create --location $Location --name $RGName

#         Get the Resource Group ID
$RGid =$(az group list --query "[?name=='$($RGName)'].[id]" --output tsv)

#           Creando Maquinas Virtuales                
for ($i = 1; $i -le $TotalNodes; $i++)
{
  $VMNodeName = "$VMName" + "$i"

  echo "Creating Virtual Machine: $VMNodeName ........"
  az vm create `
    --name $VMNodeName `
    --resource-group $RGName `
    --location $Location `
    --image $ImageUrnAlias `
    --size $Size `
    --authentication-type  $AuthType `
    --admin-username $AdminUserName `
    --ssh-key-values $SshPublicKey `
    --storage-sku $StorageType `
    --os-disk-size-gb $OsDiskSize  


  $NSGname="$VMNodeName" + "NSG"

  #        Actualizando Grupo de Seguridad de Red     
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
    --name allow-http-jbpm-business-central `
    --protocol tcp `
    --priority 101 `
    --destination-port-ranges 8080 `
    --access Allow

  az network nsg rule create `
    --resource-group $RGName `
    --nsg-name $NSGname `
    --name allow-http-jbpm `
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
         
  az vm extension set `
    --name customScript `
    --publisher Microsoft.Azure.Extensions `
    --resource-group $RGName `
    --settings '{\"fileUris\":[\"https://raw.githubusercontent.com/johnaFK/azure/CLI-Scripts/CLI%20Scripts/install-docker-on-linux.sh\"], \"commandToExecute\": \"./install-docker-on-linux.sh\"}' `
    --vm-name $VMNodeName 
}	



echo "The creation of the VM with drools has finished."
