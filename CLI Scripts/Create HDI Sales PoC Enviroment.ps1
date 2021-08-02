$ServiceName="salespoc"
$EnviromentName="test"
$Location="centralus" 

$RGName="$ServiceName-$EnviromentName-rg"

$ServerName="$($ServiceName)-sql-server"
$AdminUser="$($ServiceName)user"
$AdminPwd="abcDEF123$"

$FirewallRuleName="AllowMyIPRule"
$StartIP="177.228.35.143"
$EndIP="177.228.35.143"
$DbName="ArticlesDb"
$DbServiceObjective="Basic"

$DbStructureScriptPath="$PSScriptRoot\sales-poc-scripts\articlesdb-scripts.sql"





& $PSScriptRoot"\Create Resource Group.ps1" $Location $RGName

& $PSScriptRoot"\Create Relational Db.ps1" $ServerName $RGName $AdminUser $AdminPwd $Location $FirewallRuleName $StartIP $EndIP $DbName $DbServiceObjective

echo "Create database structure......"
sqlcmd -U $AdminUser -P $AdminPwd -S $ServerFullyDomainName -d $DbName -i $DbStructureScriptPath


