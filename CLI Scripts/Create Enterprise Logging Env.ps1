param(
    [Parameter(Mandatory, HelpMessage="The company of the service")]
    [string]$Company,

    [Parameter(Mandatory, HelpMessage="The business domain of the service")]
    [string]$BusinessDomain,

    [Parameter(Mandatory, HelpMessage="The name of the service")]
    $ServiceName,

    [Parameter(Mandatory)]
    $EnviromentName,

    [Parameter(Mandatory)]
    $StorageContainerName,

    $Location ="southcentralus", 
    $LocationAbr="scus",
    $StorageAccountRedundancy="Standard_LRS",
    $evhnsSku="Standard",
    $PartitionCount="2",
    $RetentionTime="1",
    $EnableCapture="true",
    $TimeWindow="240",
    $SizeWindow="10485760",
    $CleanupPolicy="Delete",
    $SkipEmptyArchives="true"
)

$RGName="rg-$BusinessDomain-$ServiceName-$EnviromentName-$LocationAbr-01"

& $PSScriptRoot"\az-group-create.ps1" $Location $RGName

$StorageAccountName="st$Company$ServiceName$EnviromentName01"

& $PSScriptRoot"\az-storage-account-create.ps1" $StorageAccountName $RGName $StorageAccountRedundancy 

& $PSScriptRoot"\az-storage-container-create.ps1" $StorageContainerName $StorageAccountName

$evhnsName="evhns-$BusinessDomain-$ServiceName-$EnviromentName-$LocationAbr-01"

& $PSScriptRoot"\az-eventhubs-namespace-create.ps1" $evhnsName $RGname $evhnsSku

$evhName="evh-$BusinessDomain-$ServiceName-log-$EnviromentName-$LocationAbr-01"

$DestinationName="EventHubArchive.AzureBlockBlob"

& $PSScriptRoot"\az-eventhubs-eventhub-create.ps1" $evhName $RGname $evhnsName $PartitionCount $CleanupPolicy `
    $RetentionTime $EnableCapture $StorageAccountName $StorageContainerName $DestinationName $TimeWindow $SizeWindow `
    $SkipEmptyArchives