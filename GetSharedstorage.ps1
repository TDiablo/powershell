

# Get all datastores.
$datastores = Get-Datastore -refresh -datacenter ENVS

#Loop through all of the datastores
foreach ($datastore in $datastores)
{
#If it is true it is a shareable datastore
If ($datastore.extensiondata.summary.MultipleHostAccess -eq $true)
    {
    $Currentdisksize=$datastore.FreeSpaceMB
    #Write-Output $datastore
    #Write-Output $disksize
       If ($Currentdisksize -gt $CurrentMaxSize)
        {
        $CurrentMaxSize = $Currentdisksize
        $Maxdatastore = $datastore
       
        }
    }

}

 Write-Output $MaxDataStore