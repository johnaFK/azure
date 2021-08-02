Param(
    [string] $ServerName,
    [string] $RGname,
    [string] $AdminUser,
    [string] $AdminPwd,
    [string] $Location,
    [string] $StartIP,
    [string] $EndIP,
    [string] $DbName,
    [string] $DbServiceObjective
)

echo "----------------------------------------------------------"
echo "|                                                         |"
echo "|      Creando servidor de base de datos $DbName          |"
echo "|                                                         |"
echo "----------------------------------------------------------"
az sql server create -l $Location -g $RGname -n $ServerName -u $AdminUser -p $AdminPwd


az sql server firewall-rule create -g $RGname -s $ServerName -n AllowYourIp --start-ip-address $StartIP --end-ip-address $EndIP

echo "----------------------------------------------------------"
echo "|                                                         |"
echo "|         Creando base de datos $DbName                   |"
echo "|                                                         |"
echo "----------------------------------------------------------"

az sql db create -g $RGname -s $ServerName -n $DbName --service-objective $DbServiceObjective