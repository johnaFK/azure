param(
    [Parameter(Mandatory, HelpMessage="The name of the service")]
    $ServiceName,

    [Parameter(Mandatory)]
    $EnviromentName,
    
    [Parameter(Mandatory)]
    $DbName,

    $Location = "centralus",
    $RGName = "$ServiceName-$EnviromentName-rg",

    $ServerName = "$($ServiceName)-sql-server",
    $AdminUser = "$($ServiceName)user",
    $AdminPwd = "abcDEF123$",

    $FirewallRuleName = "AllowMyIPRule",
    $StartIP = "200.76.181.6",
    $EndIP = "200.76.181.6",
    $DbServiceObjective = "Basic",
    $DbScript = "articlesdb-scripts.sql"
)

$DbStructureScriptPath = "$PSScriptRoot\sales-poc-scripts\$DbScript"

& $PSScriptRoot"\Create Resource Group.ps1" $Location $RGName

& $PSScriptRoot"\Create Relational Db.ps1" $ServerName $RGName $AdminUser $AdminPwd $Location $FirewallRuleName $StartIP $EndIP $DbName $DbServiceObjective

echo "Create database structure......"
echo $ServerFullyDomainName
sqlcmd -U $AdminUser -P $AdminPwd -S $ServerFullyDomainName -d $DbName -i $DbStructureScriptPath


