param(
    [Parameter(Mandatory, HelpMessage="The name of the service")]
    $ServiceName,

    [Parameter(Mandatory)]
    $EnviromentName
)

$Location = "centralus"
$LocationAbr="scus"
$RGName = "$ServiceName-$EnviromentName-rg"

& $PSScriptRoot"\az-group-create.ps1" $Location $RGName

$RGid =$(az group list --query "[?name=='$RGName'].[id]" --output tsv)

$VMName="$EnviromentName-$ServiceName-servers-$LocationAbr"
$ImageUrnAlias="CentOS"
$Size="Standard_B2s"
$AuthType="ssh"
$AdminUserName="linadmin"
$SshPublicKey="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDQl+aQ/wEjfcFO6GU2f7vWQHbgkSnZiDqIaRoJYSgxR71bXc5TTCfwlBamfl3Y930a6e6VPT/MYEM+gc4qfnulHMGmFOfrDr4qh3yItBa1zC0ZeRluYvYYs7Ujt/qS2rf/ZfxE3R+VAwKVYE+8dMeiEfiY5fPtdxo8cTA3O9f/rvNFf1H+anshNpJ6BR4Dnz4w7Phm5r+zJDkbuIz9+qTQcD3Yin95fmBptv9FK1KvhdVsA9F+ApsyWrC9BYBOWpK3Ee+/OxejlBwjUyh3Z5pc52sFz0H1VyytQzph2xXmcCCxfR9tyg3m4S0q9EdRWsu62hsdZAsZI6vN8lOztk6jC9JQCWw1bn9ocfTghoE7cM4nmZWiy5AZEtDyZVmDjDOJ2Xd1plg/z1f/HNAyEXnmT32vEy0KkUvNntRiarlFOBtSj+K1pBbn5IodKeVk8FdJsmiWArwFoW7N012zTXScCOGzQrxizgZPKZSTo/B5YjZz5FRIgucijEgbneYUFVPZwL2sZNSIB4qfWH8gwiSLGNukMusGsSitR2E9HUu+etWg1Ab+7fVH3B3ci9+M93Jxz7EGHDuruJ6kAZtcLSqIYdm/S580gNcXvpxl7HtbikVp6exss5FmIFhz6+NadFjRzz+8hBUtJ5s+RL6ygcCcLspMh2edEUsV8/RMjJftbQ== hdi`430007270@H37392LCOLEO"
$StorageType="Standard_LRS"
$OsDiskSize="64"

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

& $PSScriptRoot"\az-vm-extension-set.ps1" `
    Docker `
    customScript `
    Microsoft.Azure.Extensions `
    $RGName `
    '{\"fileUris\":[\"https://raw.githubusercontent.com/johnaFK/azure/CLI-Scripts/CLI%20Scripts/install-docker-on-linux.sh\"], \"commandToExecute\": \"./install-docker-on-linux.sh\"}' `
    $VMName 

& $PSScriptRoot"\az-vm-extension-set.ps1" `
    WS02ei-integrator `
    customScript `
    Microsoft.Azure.Extensions `
    $RGName `
    '{\"fileUris\":[\"https://raw.githubusercontent.com/johnaFK/azure/CLI-Scripts/CLI%20Scripts/install-wso2-integrator-on-linux.sh\"], \"commandToExecute\": \"./install-wso2-integrator-on-linux.sh\"}' `
    $VMName 

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