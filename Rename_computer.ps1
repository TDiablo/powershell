
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
 }


Function Rename-ComputerName ([string]$NewComputerName){ 
     
    $ComputerInfo = Get-WmiObject -Class Win32_ComputerSystem 
    $ComputerInfo.rename($NewComputerName) 
     
    } 

Rename-ComputerName CANAPI2

#Reboot VM
#Restart-VM CANAPI2 -confirm:$false