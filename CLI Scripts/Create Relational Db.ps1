Param(
    [string] $ServerName,
    [string] $RGname,
    [string] $AdminUser,
    [string] $AdminPwd,
    [string] $Location,
    [string] $FirewallRuleName,
    [string] $StartIP,
    [string] $EndIP,
    [string[]] $DbName,
    [string] $DbServiceObjective
)

echo "Creating Database Server: $ServerName ........"
az sql server create -l $Location -g $RGname -n $ServerName -u $AdminUser -p $AdminPwd

echo "Creating Firewall Rule for Database Server: $ServerName ........"
az sql server firewall-rule create -g $RGname -s $ServerName -n cellphone --start-ip-address 201.166.158.116 --end-ip-address 201.166.158.116
az sql server firewall-rule create -g $RGname -s $ServerName -n hdi --start-ip-address 200.76.181.6 --end-ip-address 200.76.181.6
az sql server firewall-rule create -g $RGname -s $ServerName -n casa --start-ip-address 177.228.35.143 --end-ip-address 177.228.35.143

foreach ($db in $DbName) {
    echo "Creating Database $db ......" 
    az sql db create -g $RGname -s $ServerName -n $db --service-objective $DbServiceObjective

    $ConnectionString=$(az sql db show-connection-string -s $ServerName -n $db -c ado.net)
    
    echo "ADO.NET Connection String: $ConnectionString"

}

$ServerFullyDomainName = $(az sql server list -g $RGname --query "[?name=='$ServerName'].[fullyQualifiedDomainName]" --output tsv)

