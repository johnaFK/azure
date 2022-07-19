param(
    [Parameter(Mandatory, HelpMessage="The name of the service")]
    $ServiceName,

    [Parameter(Mandatory)]
    $EnviromentName,

    $Location = "centralus", 
    $LocationAbr="scus",
    $ImageUrnAlias="CentOS",
    $StorageType="Standard_LRS",
    $OsDiskSize="64",
    $Size="Standard_B2s",
    $AuthType="ssh",
    $AdminUserName="linadmin",
    $SshPublicKey="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDQl+aQ/wEjfcFO6GU2f7vWQHbgkSnZiDqIaRoJYSgxR71bXc5TTCfwlBamfl3Y930a6e6VPT/MYEM+gc4qfnulHMGmFOfrDr4qh3yItBa1zC0ZeRluYvYYs7Ujt/qS2rf/ZfxE3R+VAwKVYE+8dMeiEfiY5fPtdxo8cTA3O9f/rvNFf1H+anshNpJ6BR4Dnz4w7Phm5r+zJDkbuIz9+qTQcD3Yin95fmBptv9FK1KvhdVsA9F+ApsyWrC9BYBOWpK3Ee+/OxejlBwjUyh3Z5pc52sFz0H1VyytQzph2xXmcCCxfR9tyg3m4S0q9EdRWsu62hsdZAsZI6vN8lOztk6jC9JQCWw1bn9ocfTghoE7cM4nmZWiy5AZEtDyZVmDjDOJ2Xd1plg/z1f/HNAyEXnmT32vEy0KkUvNntRiarlFOBtSj+K1pBbn5IodKeVk8FdJsmiWArwFoW7N012zTXScCOGzQrxizgZPKZSTo/B5YjZz5FRIgucijEgbneYUFVPZwL2sZNSIB4qfWH8gwiSLGNukMusGsSitR2E9HUu+etWg1Ab+7fVH3B3ci9+M93Jxz7EGHDuruJ6kAZtcLSqIYdm/S580gNcXvpxl7HtbikVp6exss5FmIFhz6+NadFjRzz+8hBUtJ5s+RL6ygcCcLspMh2edEUsV8/RMjJftbQ== hdi`430007270@H37392LCOLEO"
    
)

$RGName="$ServiceName-$EnviromentName-rg"
$VMName="$EnviromentName-$ServiceName-wso2-$LocationAbr"
$NSGname="$VMName" + "NSG"

$DbStructureScriptPath = "$PSScriptRoot\sales-poc-scripts\$DbScript"

& $PSScriptRoot"\Create Resource Group.ps1" $Location $RGName

& $PSScriptRoot"\az-vm-create.ps1" `
    $VMname `
    $RGname `
    $Location `
    $ImageUrnAlias `
    $Size `
    $AuthType `
    $AdminUserName `
    $SshPublicKey `
    $StorageType `
    $OsDiskSize

& $PSScriptRoot"\az-network-nsg-rule-create" `
    $RGname `
    $NSGname `
    wso2-esb-passthrough-nio-https-transport-first `
    tcp `
    100 `
    8280 `
    Allow
  
& $PSScriptRoot"\az-network-nsg-rule-create" `
    $RGname `
    $NSGname `
    wso2-esb-passthrough-nio-https-transport-second `
    tcp `
    101 `
    8243 `
    Allow
  
& $PSScriptRoot"\az-network-nsg-rule-create" `
    $RGname `
    $NSGname `
    wso2-esb-https-servlet `
    tcp `
    102 `
    9443 `
    Allow

Write-Output "Installing Docker...."
& $PSScriptRoot"\az-vm-extension-set.ps1" `
    customScript `
    Microsoft.Azure.Extensions `
    $RGName `
    '{\"fileUris\":[\"https://raw.githubusercontent.com/johnaFK/azure/CLI-Scripts/CLI%20Scripts/install-docker-on-linux.sh\"], \"commandToExecute\": \"./install-docker-on-linux.sh\"}' `
    $VMName 

Write-Output "Installing WSO2-EI...."
    & $PSScriptRoot"\az-vm-extension-set.ps1" `
        customScript `
        Microsoft.Azure.Extensions `
        $RGName `
        '{\"fileUris\":[\"https://raw.githubusercontent.com/johnaFK/azure/CLI-Scripts/CLI%20Scripts/install-wso2-micro-integrator-on-linux.sh\"], \"commandToExecute\": \"./install-wso2-micro-integrator-on-linux.sh\"}' `
        $VMName 

Write-Output "The creation of the VM with WSO2 Enterprise Integrator has finished."

$VMpublicIp = $(az vm show -d --name $VMName --resource-group $RGName --query "publicIps" -o tsv)
Write-Output "The public IP for the VM is: $VMpublicIp"
