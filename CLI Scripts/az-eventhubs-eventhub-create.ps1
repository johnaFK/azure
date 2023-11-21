Param([string]$Name, [string]$RGName, [string]$evhnsName, [string]$PartionCount, [string]$CleanupPolicy, `
		[string]$RetentionTime, [string]$EnableCapture, [string]$StorageAccount, [string]$BlobContainerName, `
		[string]$DestinationName, [string]$TimeWindow, [string]$SizeWindow, [string]$SkipEmptyArchives) 
echo "Creating Event Hubs Capture $Name........................"

az eventhubs eventhub create `
	--name $Name `
	--resource-group $RGName `
	--namespace-name $evhnsName `
	--partition-count $PartionCount `
	--cleanup-policy $CleanupPolicy `
	--retention-time $RetentionTime `
	--enable-capture $EnableCapture `
	--storage-account $StorageAccount `
	--blob-container $BlobContainerName `
	--destination-name $DestinationName `
	--capture-interval $TimeWindow `
	--capture-size-limit $SizeWindow `
	--skip-empty-archives $SkipEmptyArchives
