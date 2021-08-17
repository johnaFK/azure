Param(
    [string] $RGname,
    [string] $NSGname,
    [string] $RuleName,
    [string] $Protocol,
    [string] $Priority,
    [string] $PortRange,
    [string] $Access
)

Write-Output "Creating Network Security Group Rule: $NSGName ........"

az network nsg rule create `
  --resource-group $RGName `
  --nsg-name $NSGname `
  --name $RuleName `
  --protocol $Protocol `
  --priority $Priority `
  --destination-port-ranges $PortRange `
  --access $Access