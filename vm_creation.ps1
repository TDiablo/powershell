#READ THE INPUT FILE
#$strFileIn

#$INFILE = (get-content $csv)
$strFileIn="C:\PSHELL\CAN.CSV"
#if the length = 0 no command line options were passed so fire up the gui

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


$VMCommand="New-VM -Name $vmname -VMHost pmiesx036.pmint.pmihq.org -DiskMB $disk_size -MemoryMB $memory_size -NetworkName ""ENVS Support"" -Location $location -DiskStorageFormat Thin -GuestID windows7Server64Guest" 


Invoke-Expression -command $VMCommand

Write-Host "VM Created: " $vmname ", Hard Disk: " $disk_size ", Memory: " $memory_size
 
#Write-Host $vmname, $disk_size,  $memory_size,  $location 

}