Param(
    [string] $VMname,
    [string] $RGname,
    [string] $Location,
    [string] $ImageUrnAlias,
    [string] $Size,
    [string] $AuthType,
    [string] $AdminUserName,
    [string] $SshPublicKey,
    [string] $StorageType,
    [string] $OsDiskSize
)

echo "Creating Virtual Machine: $VMname ........"
az vm create `
	--name $VMname `
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