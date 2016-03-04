#PURPOSE: DEPLOY VM'S BASED ON TEMPLATE FROM .CSV
#Version 1.0
#based on script found on Internet.
#This version uses a direct call from the template to do the install

#the install parameter is $PostInstall
#this should be removed and put in the csv file

#PARAMETERS FOR THE SCRIPT
#Param([string] $CSV = $(throw write-host "NO CSV FILE! [ERROR]" -ForeGroundColor Red)
#)

#ADD VMWARE PSSNAPIN
Add-PSSnapin -Name "VMware.VimAutomation.Core"

#FORCE TO LOAD VMWARE POWERSHELL PLUGIN
[Reflection.Assembly]::LoadWithPartialName("vmware.vim")

#ON ERROR CONTINUE
$ErrorActionPreference = "Stop"


#----------------------------------------------------------
#STATIC VARIABLES
#----------------------------------------------------------
$boolMailResults=$false
$vcserver = "goc1envvcr01v.pmint.pmihq.org"
$AutoLogon = "True"
$LogOnCount = "2"
$TimeZone = "035"
$Password = "Password1"			#ADMIN PASSWORD IN PLAIN TEXT
$OrgName = "PMI"
$FullName = "PMI"
$ProdCode = "CPKY6-QYC8Q-H8MGX-K7PCY-D8RFT"
$PostInstall = "C:\vmrequirements\STG01\joindomainSTG01OU-Base.cmd"
$TimeOut = "10"			#TIMEOUT BETWEEN DEPLOYMENT
$STARTLINE = 1
$SleepShutdown = "30"		#TIMEOUT FOR SHUTDOWN VM
$SleepRemove = "30"			#TIMEOUT FOR REMOVE VM
$output = "datastoreinfo.txt"    #where we dump the data store details
$rescanNumVM = 2
$emailNotification
$rundate=get-date -format g

#store the prefered name
$prefreredStore
$boolDataStoreScanned=$False
#use this to check the number of VMs deployed.
$intVMDeployedCount = 0

$SmtpClient = new-object system.net.mail.smtpClient 
$MailMessage = New-Object system.net.mail.mailmessage 
$SmtpClient.Host = "172.19.0.151" 
$mailmessage.from = "deploycomplete@pmi.org" 
#MAIL TO MESSAGE SHOULD BE PASSED IN FROM SPREADSHEET
#$mailmessage.To.add("hans.bader@pmi.org") 




#----------------------------------------------------------
#LOGFILE VARIABLES
#----------------------------------------------------------

$date = get-date
$yr = $date.Year.ToString()
$mo = $date.Month.ToString()
$dy = $date.Day.ToString()

$logfile = $yr + "-" + $mo + "-" + $dy + ".log"

#----------------------------------------------------------
#Space Functions VARIABLES
#----------------------------------------------------------


function UsedSpace
{
	param($ds)
	[math]::Round(($ds.CapacityMB - $ds.FreeSpaceMB)/1024,2)
}

function FreeSpace
{
	param($ds)
	[math]::Round($ds.FreeSpaceMB/1024,2)
}

function PercFree
{
	param($ds)
	[math]::Round((100 * $ds.FreeSpaceMB / $ds.CapacityMB),0)
}

#----------------------------------------------------------
#FUNCTION SCAN Data Stores
#----------------------------------------------------------

function GetDataStoreInfo
{
	$Datastores = Get-Datastore
	$rundate=get-date -format g
	$details="Report Generated " + $rundate
	Add-Content $output $details

	$details = "There are " + $Datastores.length + " datastores" + "`n"
	Add-Content $output $details
	$colDataStoreVMS = @()
	$colDataStoreVMS = @{"blank" = 99999 }

	#Create an Array with the name of the datastore and the number of Running
	#VMs, each time a VM is added to a LUN, increase the number of running VMs
	#always update the array containing the number of running VMs
	
	#Store the least running vms
	#Set the seed to 100 VMS.
	#We never have more than 16 VMS per datastore so this will update the number of VMS
	$minRunningVMs=100

	#Check we don't deploy to any LUNS with less than 10 percent free space 
	#set the percent free Space limit
	$percentFreeRequired=10


	foreach ($LUN in $Datastores)
	{
	 
		 $a = (Get-vm -Datastore $LUN)
		 $runningVMCount = 0
		  foreach($vm in $a)
		  {
				if ($vm.PowerState -eq "PoweredOn")
				{
				$runningVMCount++
				}  

			}
			$dataStoreName=$LUN.Name
			$freeSpace=$LUN.FreeSpaceMB
			$freeSpace=$LUN.FreeSpaceMB
			$totalSpace=$LUN.CapacityMB
			$percentFree=[math]::Round(($freeSpace/$totalSpace)*100)
			$colDataStoreVMS[$dataStoreName] = $runningVMCount
			$details="Datastore is " + $dataStoreName + ". The percentage diskspace free is " + $percentFree + "%. The number of running vms is " + $runningVMCount + "`n"
			Add-Content $output $details
			#At this point update the prefered VM
			# we don't use fiber channel anymore so we parse the FC and exlcude it
			
			#if ($dataStoreName.Contains("SATA")) 
			#{
				if ($runningVMCount -le  $minRunningVMs)
				{
					if($percentFree -ge $percentFreeRequired)
					{
						$prefreredStore=$dataStoreName
						$minRunningVMs=$runningVMCount
						$preferedPercentFree=$percentFree
					}
			#	}
			}
			$runningVMCount = 0
	}

	$details="The prefered data store is for new deployments is : " + $prefreredStore + " This data store has " + $minRunningVMs  + " Running VMS " + "and is has " +  $preferedPercentFree + "% disk space free"

	Add-Content $output $details
	$boolDataStoreScanned=$True
	return $prefreredStore
}


#----------------------------------------------------------
#FUNCTION Select-FileDialog
#----------------------------------------------------------


function Select-FileDialog
{
	param([string]$Title,[string]$Directory,[string]$Filter="All Files (*.*)|*.*")
	[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null
	$objForm = New-Object System.Windows.Forms.OpenFileDialog
	$objForm.InitialDirectory = $Directory
	$objForm.Filter = $Filter
	$objForm.Title = $Title
	$Show = $objForm.ShowDialog()
	If ($Show -eq "OK")
	{
		Return $objForm.FileName
	}
	Else
	{
		Write-Error "Operation cancelled by user."
	}
}





#----------------------------------------------------------
#FUNCTION CREATE_LOG
#----------------------------------------------------------
Function CREATE_LOG
{
#TEST IF THE OLD FILE EXISTS
Test-Path $logfile
	if (! $?)
		#THE FILE DOES NOT EXIST, SO WE CREATE A NEW LOGFILE
		{new-item $logfile -type file}
		
			if (! $?)
				{write-ouput "FAILED TO CREATE LOGFILE"
				Exit}
}

#----------------------------------------------------------
#FUNCTION WRITE_LOG
#----------------------------------------------------------
Function WRITE_LOG
{
Param([string]$MESSAGE)


$logdate = get-date
$logyr = $logdate.Year.ToString()
$logmo = $logdate.Month.ToString()
$logdy = $logdate.Day.ToString()
$loghr = $logdate.Hour.ToString()
$logmi = $logdate.Minute.ToString()
$logsc = $logdate.Second.ToString()

$logstamp = $logyr + "-" + $logmo + "-" + $logdy + " " + $loghr + ":" + $logmi + ":" + $logsc + "`t" + $MESSAGE

write-output $logstamp | Out-File $logfile -append

}


#----------------------------------------------------------
#FUNCTION CREATEVM
#----------------------------------------------------------
Function CREATEVM {
			
#connect to VirtualCenter with credentials
connect-viserver -server $vcserver 
			
			
#VIRTUAL MACHINE DATASTORE AND CLUSTER LOCATION SPECIFICATION
			
$vmrSpec = New-Object VMware.Vim.VirtualMachineRelocateSpec 
			
			
#DATASTORE
$LUN = get-datastore $datastore
$LUNview = get-view $LUN.id
$vmrSpec.datastore = $LUNview.moref

		
#RESOURCE POOL
if ($CLUSPOOL -eq $True)
	{
	$cluster = Get-View (get-cluster $vmcluster).id
	$vmrSpec.pool = $cluster.resourcepool
	}
elseif ($HOSTPOOL -eq $True)
	{	
	$pool = get-view -ViewType ComputeResource | where { $_.Name -eq $vmesxhost }
	$vmrSpec.pool = $pool.Resourcepool		
	}
else	
	{		
	$pool = get-resourcepool $vmpool
	$poolview = get-view $pool.id
	$vmrSpec.pool = $poolview.moref
	}


		
			
#CLONE SPECIFICATIONS
			
			$vmcSpec = New-Object VMware.Vim.VirtualMachineCloneSpec
			$vmcSpec.Customization = New-Object VMware.Vim.CustomizationSpec
			
			#DATASTORE SPECIFICATION
			$vmcSpec.location = $vmrSpec
			
			#TURN VM ON AFTER CLONING
			$vmcSpec.powerOn = $true
			
			#VIRTUAL MACHINE IS NOT A TEMPLATE
			$vmcSpec.template = $false
			
			
#NETWORK CONFIGURATION CLONE SPECIFICATIONS
			
			#CREATE OBJECT CUSTOMIZATIONADAPTERMAPPING
			$vmcSpec.Customization.NicSettingMap = @(New-Object VMware.Vim.CustomizationAdapterMapping)
			
			#CREATE OBJECT CUSTOMIZATIONIPSETTINGS
			$vmcSpec.Customization.NicSettingMap[0].Adapter = New-Object VMware.Vim.CustomizationIPSettings
			
			#CREATE OBJECT CUSTOMIZATIONFIXEDIP
			$vmcSpec.Customization.NicSettingMap[0].Adapter.Ip = New-Object VMware.Vim.CustomizationFixedIp
			
			#NETWORK SPECIFICATIONS
			$vmcSpec.Customization.NicSettingMap[0].Adapter.Ip.IpAddress = $ip
			$vmcSpec.Customization.NicSettingMap[0].Adapter.SubnetMask = $subnetmask
			$vmcSpec.Customization.NicSettingMap[0].Adapter.Gateway = $gateway
			$vmcSpec.Customization.NicSettingMap[0].Adapter.DnsServerList = $dns
			
			#CREATE OBJECT CUSTOMIZATIONGLOBALIPSETTINGS
			$vmcSpec.Customization.GlobalIPSettings = New-Object VMware.Vim.CustomizationGlobalIPSettings
			
			
#SYSPREP CLONE SPECIFICATIONS
			
			#CREATE OBJECT CUSTOMIZATIONSYSPREP
			$vmcSpec.Customization.Identity = New-Object VMware.Vim.CustomizationSysprep
			
			#CREATE OBJECT CUSTOMIZATIONGUIUNATTENDED
			$vmcSpec.Customization.Identity.GuiUnattended = New-Object VMware.Vim.CustomizationGuiUnattended
			
			#GUIUNATTENDED SPECIFICATION
			$vmcSpec.Customization.Identity.GuiUnattended.autoLogon = $AutoLogon
			$vmcSpec.Customization.Identity.GuiUnattended.autoLogonCount = $LogOnCount
			$vmcSpec.Customization.Identity.GuiUnattended.timeZone = $TimeZone
			$vmcSpec.Customization.Identity.GuiUnattended.Password = New-Object VMware.Vim.CustomizationPassword
			$vmcSpec.Customization.Identity.GuiUnattended.Password.plainText = "True"
			$vmcSpec.Customization.Identity.GuiUnattended.Password.value = $Password
			
			#CREATE OBJECT CUSTOMIZATIONIDENTIFICATION
			$vmcSpec.Customization.Identity.Identification = New-Object VMware.Vim.CustomizationIdentification
			
			#CUSTOMIZATIONIDENTIFICATION SPECIFICATION
			$vmcSpec.Customization.Identity.Identification.joinWorkgroup = "WORKGROUP"
			
			#CREATE OBJECT CUSTOMIZATIONGUIRUNONCE
			$vmcSpec.Customization.Identity.guiRunOnce = New-Object VMware.Vim.CustomizationGuiRunOnce
			
			#GUIRUNONCE SPECIFICATION
			$vmcSpec.Customization.Identity.guiRunOnce.commandList = $RunOnce
			
			
			#CREATE CUSTOMIZATIONUSERDATA
			$vmcSpec.Customization.Identity.UserData = New-Object VMware.Vim.CustomizationUserData
			
			#CUSTOMIZATIONUSERDATA SPECIFICATION
			$vmcSpec.Customization.Identity.UserData.orgName = $OrgName
			$vmcSpec.Customization.Identity.UserData.fullName = $FullName
			$vmcSpec.Customization.Identity.UserData.productId = $ProdCode
			$vmcSpec.Customization.Identity.UserData.ComputerName = New-Object VMware.Vim.CustomizationFixedName
			$vmcSpec.Customization.Identity.UserData.ComputerName.name = $vmname
			
			
			#CREATE OBJECT CUSTOMIZATIONLICENSEFILEPRINTDATA
			$vmcSpec.Customization.Identity.LicenseFilePrintData = New-Object VMware.Vim.CustomizationLicenseFilePrintData
			
			#CUSTOMIZATIONLICENSEFILEPRINTDATA SPECIFICATION
			$vmcSpec.Customization.Identity.LicenseFilePrintData.AutoMode = New-Object VMware.Vim.CustomizationLicenseDataMode
			$vmcSpec.Customization.Identity.LicenseFilePrintData.AutoMode = "perSeat"
			
			
#WIN OPTIONS CLONE SPECIFICATIONS
			
			#CREATE OBJECT CUSTOMIZATIONWINOPTIONS
			$vmcSpec.Customization.Options = New-Object  VMware.Vim.CustomizationWinOptions
			
			#CHANGE SID
			$vmcSpec.Customization.Options.changeSID = 1
			
#Create The annotation TExt

$vmcSpec.config = New-Object VMware.Vim.VirtualMachineConfigSpec

$annotationText="" + $vmnotes + "    Date VM Created " + $rundate 

$vmcSpec.config.annotation = $annotationText

#CLONE TASK

			#GET VM FOLDER
			$target = Get-Folder $vmfolder
			$targetview = get-view $target.ID
			
			#GET TEMPLATE
			$vmmor = Get-Template -Name $vmtemplate 
			$vmmorview = get-view $vmmor.id
			
			#CLONE TASK
			write-output "The VM being cloned is " $vmname
			$task = $vmmorview.CloneVM_Task($targetview.MoRef,$vmname, $vmcSpec )

			
				
			WRITE_LOG "Finished"

if ($boolMailResults -eq $true)
{
		$mailmessage.Subject = “Deploy of server ” + $vmname
		$mailmessage.Body = “The cloning of the server is complete” 
		$mailmessage.Headers.Add("message-id", "<3BD50098E401463AA228377848493927-1>") 
		$mailmessage.To.add($emailNotification)
		$smtpclient.Send($mailmessage) 
		
}			
#TIMEOUT BETWEEN JOBS
			sleep $Timeout
}

#----------------------------------------------------------
#FUNCTION CHECKEXIST_VM
#----------------------------------------------------------
Function CHECKEXIST_VM
{
Param([string]$VM)

$ARRVM = get-vm | where { $_.Name -eq $VM }

#CHECK IF THE THE ARRAY IS FILLED 
				
	if ($ARRVM -eq $null) { 
	return $False }
	else { return $True }
	
	write-output
}

#----------------------------------------------------------
#FUNCTION SHUTDOWN_VM
#----------------------------------------------------------
Function SHUTDOWN_VM
{
Param([string]$VM)

#SHUTDOWN THE GUEST
get-vm | where { $_.Name -eq $VM } | Stop-VM -Confirm:$False

#WAIT FOR THE VM TO SHUTDOWN 
sleep $SleepShutdown

#ERROR HANDLING
	if (! $?)
	{ return $False }
	else
	{return $True }

}

#----------------------------------------------------------
#FUNCTION REMOVE_VM
#----------------------------------------------------------
Function REMOVE_VM
{
Param([string]$VM)

#SHUTDOWN THE GUEST
get-vm | where { $_.Name -eq $VM } | Remove-VM -DeleteFromDisk -Confirm:$False

#WAIT FOR THE VM TO BE REMOVED 
sleep $SleepRemove

#ERROR HANDLING
	if (! $?)
	{ return $False }
	else
	{return $True }

}


#----------------------------------------------------------
#FUNCTION CHECK_DATASTORE
#----------------------------------------------------------
Function CHECK_DATASTORE
{
Param([string]$STORE)

$ARRSTORE = get-datastore | where { $_.Name -eq $STORE }

if ($ARRSTORE -eq $null)
	{return $False}
else
	{return $True}
}	

#----------------------------------------------------------
#FUNCTION CHECK_CLUSTER
#----------------------------------------------------------
Function CHECK_CLUSTER
{
Param([string]$GETCLUSTER)

$ARRCLUSTER = get-cluster | where { $_.Name -eq $GETCLUSTER }

if ($ARRCLUSTER -eq $null)
	{return $False}
else
	{return $True}
}


#----------------------------------------------------------
#FUNCTION CHECK_POOL
#----------------------------------------------------------
Function CHECK_POOL
{
Param([string]$GETPOOL)

$ARRPOOL = get-resourcepool | where { $_.Name -eq $GETPOOL }


if ($ARRPOOL -eq $null)
	{return $False}
else
	{return $True}
}

#----------------------------------------------------------
#FUNCTION CHECK_FOLDER
#----------------------------------------------------------
Function CHECK_FOLDER
{
	Param([string]$GETFOLDER)

	$ARRFOLDER = get-folder | where { $_.Name -eq $GETFOLDER}

	if ($ARRFOLDER -eq $null)
		{return $False}
	else
		{return $True}
}


#----------------------------------------------------------
#FUNCTION CHECK_TEMPLATE
#----------------------------------------------------------
Function CHECK_TEMPLATE
{
	Param([string]$GETTEMPLATE)

	$ARRTEMPLATE = get-template | where { $_.Name -eq $GETTEMPLATE}

	if ($ARRTEMPLATE -eq $null)
		{return $False}
	else
		{return $True}
}

#----------------------------------------------------------
#FUNCTION CHECK_HOST
#----------------------------------------------------------
Function CHECK_HOST
{
	Param([string]$GETHOST)

	$ARRHOST = get-vmhost | where { $_.Name -eq $GETHOST}

	if ($ARRHOST -eq $null)
		{return $False}
	else
		{return $True}
}




#----------------------------------------------------------
#MAIN SCRIPT SECTION
#----------------------------------------------------------
WRITE_LOG "START CREATING VM'S"

#READ THE FILE
#____ $INFILE = (get-content $csv)

#READ THE FILE
$strFileIn

#$INFILE = (get-content $csv)
$strFileIn=$args[0]
#if the length = 0 no command line options were passed so fire up the gui

if ($args.length -eq 0)
{ 
	$strFileIn = Select-FileDialog
}

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
	$datastore = $STRLINE[1]
	$ip = $STRLINE[2]
	$subnetmask = $STRLINE[3]
	$gateway = $STRLINE[4]
	$dns = $STRLINE[5]
	$vmcluster = $STRLINE[6]
	$vmesxhost = $STRLINE[7]
	$vmpool = $STRLINE[8]
	$vmfolder = $STRLINE[9]
	$vmtemplate = $STRLINE[10]
	$vmremove = $STRLINE[11]
	$vmnotes=$STRLINE[12]
	$emailNotification=$STRLINE[13]


#CHECK IF THE VALUES ARE CORRECT AND THE OBJECTS IN VI
$ERRCOUNTERVI = 0

#CONNECT TO VIRTUALCENTER WITH CREDENTIALS
connect-viserver -server $vcserver

#CHECK IF NAME IS SPECIFIED
if ($vmname -eq "")
	{
	WRITE_LOG "VIRTUAL MACHINE NAME MISSING"
	$ERRCOUNTERVI = $ERRCOUNTERVI + 1
	}

#CHECK IF IP IS SPECIFIED	
if ($ip -eq "")
	{
	WRITE_LOG "VIRTUAL MACHINE IP MISSING"
	$ERRCOUNTERVI = $ERRCOUNTERVI + 1
	}

#CHECK IF SUBNET IS SPECIFIED	
if ($subnetmask -eq "")
	{
	WRITE_LOG "VIRTUAL MACHINE SUBNETMASK MISSING"
	$ERRCOUNTERVI = $ERRCOUNTERVI + 1
	}	
		
#CHECK IF GATEWAY IS SPECIFIED	
if ($gateway -eq "")
	{
	WRITE_LOG "VIRTUAL MACHINE GATEWAY MISSING"
	$ERRCOUNTERVI = $ERRCOUNTERVI + 1
	}

#CHECK IF DNS IS SPECIFIED	
if ($dns -eq "")
	{
	WRITE_LOG "VIRTUAL MACHINE DNS MISSING"
	$ERRCOUNTERVI = $ERRCOUNTERVI + 1
	}	

#CHECK IF $vmnotes IS SPECIFIED	
if ($vmnotes -eq "")
	{
	WRITE_LOG "No Notes applied"
	}		
		
#CHECK IF $emailNotification IS SPECIFIED	
if ($emailNotification -eq "")
	{
	WRITE_LOG "No Email Field"
	$boolMailResults = $false
	}
	else
	{
		$boolMailResults = $true
	}
#CHECK THE DATASTORE
#This is where we to load up the datastore info
#Scan the datastores and decide where to put them.
#Only scan the datastore once.
#Set a flag that is has been scanned.



if ( $datastore -eq "")
	{
	if($intVMDeployedCount -gt $rescanNumVM)
	{
	$boolDataStoreScanned=$false
	$intVMDeployedCount=0
	WRITE_LOG "reset the VM Count"
	}
	
	#only scan the data store when needed
	if($boolDataStoreScanned -eq $False)
		{
		WRITE_LOG "scannning for datastore"
		#GetDataStoreInfo
		#$datastore=$prefreredStore
		
		$prefreredStore = GetDataStoreInfo
		WRITE_LOG "Prefered datastore is " + $prefreredStore
		$boolDataStoreScanned=$True
		}
		$dataStore = $prefreredStore
	}
	
else	
	{
		$CHECKSTORE = CHECK_DATASTORE $datastore
			if ($CHECKSTORE -eq $True) 
				{WRITE_LOG "DATASTORE: $datastore EXISTS"}
				
			else	
				{WRITE_LOG "DATASTORE: $datastore DOES NOT EXIST"
				$ERRCOUNTERVI = $ERRCOUNTERVI + 1}			
	}
		
#CHECK THE CLUSTER, ESXHOST AND RESOURCEPOOL TOGETHER, BECAUSE OF THE OVERLAP EACH OTHER, RESOURCEPOOL VALUE IS LEADING				

#SET CLUSPOOL AND HOSTPOOL TO FALSE, SO THEY ARE EMPTY WHEN THE CHECK STARTS
$CLUSPOOL = $False
$HOSTPOOL = $False

#CHECK THE RESOURCEPOOL
if ( $vmpool -eq "")
	{
	WRITE_LOG "RESOURCEPOOL MISSING"
	
		#CHECK IF CLUSTER VALUE EXISTS
		if ($vmcluster -eq "")
			{
			write-ouput "CLUSTER MISSING"
			
			
				#CHECK IF ESXHOST VALUE EXISTS
				if ($vmesxhost -eq "")
					{
					WRITE_LOG "ESX HOST MISSING"
					$ERRCOUNTERVI = $ERRCOUNTERVI + 1
					}
				else
					{
					#CHECK THE ESXHOST
					 $CHECKESXHOST = CHECK_HOST $vmesxhost
					
					if ($CHECKESXHOST -eq $True) 
						{
						WRITE_LOG "ESXHOST: $vmesxhost EXISTS"
						WRITE_LOG "ESXHOST DEFAULT RESOURCEPOOL WILL BE USED"
						$HOSTPOOL = $True
						}	
							
					else
						{
						WRITE_LOG "ESXHOST: $vmesxhost DOES NOT EXIST"
						$ERRCOUNTERVI = $ERRCOUNTERVI + 1
						}
					}		
			}		
			
		else
			{
			#CHECK THE CLUSTER
			$CHECKCLUSTER = CHECK_CLUSTER $vmcluster
					
			if ($CHECKCLUSTER -eq $True) 
				{
				WRITE_LOG "CLUSTER: $vmcluster EXISTS"
				WRITE_LOG "CLUSTER DEFAULT RESOURCEPOOL WILL BE USED"
				$CLUSPOOL = $True
				}	
					
			else
				{
				WRITE_LOG "CLUSTER: $vmcluster DOES NOT EXIST"
				$ERRCOUNTERVI = $ERRCOUNTERVI + 1
				}	
			}
	}

else
	{
	#CHECK THE RESOURCEPOOL				
	$CHECKPOOL = CHECK_POOL $vmpool
	
	if ($CHECKPOOL -eq $True) 
		{WRITE_LOG "RESOURCEPOOL: $vmpool EXISTS"}
	
		
	else
		{WRITE_LOG "RESOURCEPOOL: $vmpool DOES NOT EXIST"
			
			#CHECK IF CLUSTER VALUE EXISTS
			if ($vmcluster -eq "")
				{
				WRITE_LOG "CLUSTER MISSING"
							
					#CHECK IF ESXHOST VALUE EXISTS
					if ($vmesxhost -eq "")
						{
						WRITE_LOG "ESX HOST MISSING"
						$ERRCOUNTERVI = $ERRCOUNTERVI + 1
						}
					else
						{
							#CHECK THE ESXHOST
							 $CHECKESXHOST = CHECK_HOST $vmesxhost
										
							if ($CHECKESXHOST -eq $True) 
								{
								WRITE_LOG "ESXHOST: $vmesxhost BESTAAT"
								WRITE_LOG "ESXHOST DEFAULT RESOURCEPOOL WILL BE USED"
								$HOSTPOOL = $True
								}	
												
							else
								{
								WRITE_LOG "ESXHOST: $vmesxhost DOES NOT EXIST"
								$ERRCOUNTERVI = $ERRCOUNTERVI + 1
								}
						  }	
							
					}					
				else
						{
						#CHECK THE CLUSTER
						$CHECKCLUSTER = CHECK_CLUSTER $vmcluster
								
						if ($CHECKCLUSTER -eq $True) 
							{
							WRITE_LOG "CLUSTER: $vmcluster EXISTS"
							WRITE_LOG "CLUSTER DEFAULT RESOURCEPOOL WILL BE USED"
							$CLUSPOOL = $True
							}	
								
						else
							{
							WRITE_LOG "CLUSTER: $vmcluster DOES NOT EXIST"
							$ERRCOUNTERVI = $ERRCOUNTERVI + 1
							}	
						 }
			}			 
		
	}

		
		
			
#CHECK THE FOLDER
$CHECKFOLDER = CHECK_FOLDER $vmfolder
	if ($CHECKFOLDER -eq $True) 
		{WRITE_LOG "FOLDER: $vmfolder EXISTS"}
		
	else	
		{
		WRITE_LOG "FOLDER: $vmfolder DOES NOT EXIST"
		WRITE_LOG "THE DEFAULT FOLDER WILL BE USED"
		$vmfolder = "vm"
		}	
 
		
#CHECK THE TEMPLATE
$CHECKTEMPLATE = CHECK_TEMPLATE $vmtemplate
	if ($CHECKTEMPLATE -eq $True) 
		{
		WRITE_LOG "TEMPLATE: $vmtemplate EXISTS"
		}

	else	
		{
		WRITE_LOG "TEMPLATE: $vmtemplate DOES NOT EXIST"
		$ERRCOUNTERVI = $ERRCOUNTERVI + 1
		}					
		
#GUIRUNONCE SETTINGS
#YOU CAN ADD ADDIONATIONAL PARAMETERS
$RunOnce = $PostInstall


		
#IF VALUES ARE CORRECT AND OBJECTS EXIST CREATE THE VM
if 	($ERRCOUNTERVI -eq 0)
{
	
#CHECK IF THE VM EXISTS
#CONNECT TO VIRTUALCENTER WITH CREDENTIALS
connect-viserver -server $vcserver 
								
	#USE FUNCTION CHECKEXIST_VM
	$CHECKVM = CHECKEXIST_VM $vmname
									
									
									
	#HANDLING OF VM EXISTENS
	if ($CHECKVM -eq $False )
		{
		WRITE_LOG "VIRTUAL MACHINE DOES NOT EXIST" 
		WRITE_LOG "VIRTUAL MACHINE: $vmname WILL BE DEPLOYED"
											
		#CALL FUNCTION CREATEVM
		CREATEVM
		}
										
	else
		{ 
	 	 WRITE_LOG "VIRTUAL MACHINE ALREADY EXISTS"
											
		#CHECK IF THE VM IS MARKED TO BE REMOVED USE SWITCH
			$vmremove = $vmremove.ToLower()
			switch ($vmremove)
			{
			yes {WRITE_LOG "VIRTUAL MACHINE IS MARKED TO BE REMOVED"
				 $REMOVEVM = $True}
			no {WRITE_LOG "VIRTUAL MACHINE CANNOT BE REMOVED"
				$REMOVEVM = $False}
			default {WRITE_LOG "VIRTUAL MACHINE CANNOT BE REMOVED"
					$REMOVEVM = $False}
			}
										
											
				#CHECK IF WE MUST REMOVE THE VIRTUAL MACHINE
				if ($REMOVEVM -eq $True)
					{
					WRITE_LOG "SHUTDOWN VM: $vmname"
												
					#CALL FUNCTION SHUTDOWN_VM
					$CHECKSHUTDOWN = SHUTDOWN_VM $vmname
													
						#ERRORHANDLING
						if ($CHECKSHUTDOWN -eq $False)
							{WRITE_LOG "FAILED TO SHUTDOWN VIRTUALMACHINE: $vmname"
							Break}
														
						else
							{WRITE_LOG "REMOVE VIRTUAL MACHINE: $vmname"
														
							#CALL THE FUNCTION REMOVE_VM
							$CHECKREMOVE = REMOVE_VM $vmname
														
								#ERRORHANDLING
								if ($CHECKREMOVE -eq $False)
									{WRITE_LOG "FAILED TO REMOVE VIRTUALMACHINE: $vmname"
									Break}
																						
								else
									{WRITE_LOG "REDEPLOY VIRTUAL MACHINE: $vmname"
															
									#CALL FUNCTION CREATEVM
									CREATEVM
									}
										
								}								
					}
		}		

	 }
			$intVMDeployedCount++
#END LOOP THROUGH CSV FILE
}			