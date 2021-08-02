Param(
    [string] $ServerName,
    [string] $RGname,
    [string] $AdminUser,
    [string] $AdminPwd,
    [string] $Location,
    [string] $FirewallRuleName,
    [string] $StartIP,
    [string] $EndIP,
    [string] $DbName,
    [string] $DbServiceObjective
)

echo "Creating Database Server: $ServerName ........"
az sql server create -l $Location -g $RGname -n $ServerName -u $AdminUser -p $AdminPwd

echo "Creating Firewall Rule for Database Server: $ServerName ........"
az sql server firewall-rule create -g $RGname -s $ServerName -n $FirewallRuleName --start-ip-address $StartIP --end-ip-address $EndIP

echo "Creating Database $DbName ......" 
az sql db create -g $RGname -s $ServerName -n $DbName --service-objective $DbServiceObjective

$ConnectionString=$(az sql db show-connection-string -s $ServerName -n $DbName -c ado.net)
$ServerFullyDomainName = $(az sql server list -g $RGname --query "[?name=='$ServerName'].[fullyQualifiedDomainName]" --output tsv)

echo "ADO.NET Connection String: $ConnectionString"
