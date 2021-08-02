$ServiceName="salespoc"
$EnviromentName="test"
$Location="centralus" 

$RGName="$ServiceName-$EnviromentName-rg"

$ServerName="$($ServiceName)DbServer"
$AdminUser="$($ServiceName)User"
$AdminPwd="abcDEF123$"
$StartIP="200.23.23.23"
$EndIP="200.23.23.23"
$DbName="ArticlesDb"
$DbServiceObjective="Basic"

& $PSScriptRoot"\Create Resource Group.ps1" $Location $RGName

& $PSScriptRoot"\Create Relational Db.ps1" $ServerName $RGName $AdminUser $AdminPwd $Location $StartIP $EndIP $DbName $DbServiceObjective