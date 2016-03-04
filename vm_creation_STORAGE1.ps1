#READ THE INPUT FILE
#$strFileIn

#$INFILE = (get-content $csv)
$strFileIn="C:\PSHELL\CAN.CSV"

$INFILE = (get-content $strFileIn)

#DETERMINE THE AMOUNT OF LINES
$ENDLINE = $INFILE.Length

#GET THE CONTENT FROM STARTLINE TILL THE END
$ARRFILE = $INFILE[$STARTLINE .. $ENDLINE] 

foreach ($VM in $ARRFILE)
{	

	#SPLIT THE LINE
	$STRLINE = $VM.split(',')
   		
	#ASSIGN VALUES TO VARIABLES

	#ASSIGN VALUES TO STRINGS
	$vmname = $STRLINE[0]
	#CONVERT $VMNAME TO UPPERCASE
	$vmname = $vmname.ToUpper()
    #GET SYSTEM DRIVE SIZE
    $disk_size = $STRLINE[1]
    #RAM
    $memory_size = $STRLINE[2]
    #VM FOLDER 
    $location = $STRLINE[3]

#Get Data store with most available free space


# Get all datastores.
$MaxDataStore = Get-Datastore -datacenter ENVS | select Name,FreeSpaceMB | Sort-Object FreeSpaceMB -desc | select name -first 1

#Loop through all of the datastores
#foreach ($datastore in $datastores)
#{
#If it is true it is a shareable datastore
#If ($datastore.extensiondata.summary.MultipleHostAccess -eq $true)
#    {
#    $Currentdisksize=$datastore.FreeSpaceMB
    #Write-Output $datastore
    #Write-Output $disksize
#       If ($Currentdisksize -gt $CurrentMaxSize)
#        {
#        $CurrentMaxSize = $Currentdisksize
#        $Maxdatastore = $datastore
 #      
#        }
#    }

#}
Write-Host "Machine drive will live on " $MaxDataStore


$VMCommand="New-VM -Name $vmname -VMHost pmiesx023.pmint.pmihq.org -DiskMB $disk_size -MemoryMB $memory_size -NetworkName ""ENVS Support"" -Location $location -Datastore ""$MaxDataStore"" -GuestID windows7Server64Guest" 


Invoke-Expression -command $VMCommand
#Write-Host $VMCommand
Write-Host "VM Created: " $vmname ", Hard Disk: " $disk_size ", Memory: " $memory_size

#Write-Host $vmname, $disk_size,  $memory_size,  $location 

}