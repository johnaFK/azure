Param(
    $Name,
    $Publisher,
    $RGName,
    $Settings,
    $VMName
)

Write-Output "Installing Extension in $VMName..........."	  
az vm extension set `
  --name $Name `
  --publisher $Publisher `
  --resource-group $RGName `
  --settings $Settings `
  --vm-name $VMName 