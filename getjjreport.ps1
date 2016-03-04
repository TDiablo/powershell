#ADD VMWARE PSSNAPIN
Add-PSSnapin -Name "VMware.VimAutomation.Core"

#FORCE TO LOAD VMWARE POWERSHELL PLUGIN
#[Reflection.Assembly]::LoadWithPartialName("vmware.vim")


##
## Generate a report for each cluster with total resource allocation
##
## Still needed:
##	Output in Excel
##	Summary at the top of the output Excel Files
##	Determine whether or not a VM is powered on, is whether to count it or not
##	Mailer script to send output (hopefully in different sheets of a spreadsheet
## Changelog:
## 4-15 - Added highlighting in Excel spreadsheet for resource page
## 4-15 - Added freeze panes to Resources Page
## 12-14 - Removed highlighting when resources are "Unlimited"



# new-ExcelWorkbook.ps1
# Creates a new workbook (with just one sheet), in Excel 2007
# Then we create and save a sample worksheet
# Thomas Lee - tfl@psp.co.uk
## Change Password: read-host -assecurestring | convertfrom-securestring | out-file C:\securestring.txt


$debug = "False"

# Create Excel object
$excel = new-object -comobject Excel.Application
# Make Excel visible

if ($debug -eq "True"){
$excel.visible = $true
}
else {
$excel.Visible = $false
}


# Create a new workbook
$workbook = $excel.workbooks.add()    
# default workbook has three sheets, remove 2
$S2 = $workbook.sheets | where {$_.name -eq "Sheet2"}
$s3 = $workbook.sheets | where {$_.name -eq "Sheet3"}
$s3.delete()
$s2.delete()
# Get sheet and update sheet name
$s1 = $workbook.sheets | where {$_.name -eq 'Sheet1'}
$s1.Name = "Summary Page"
#$s1.delete()
$SummSheet = $workbook.sheets | where {$_.name -eq "Summary Page"}




##Population of Date Variables for Snapshot calculation
$today = Get-Date
$40daysago = $today.AddDays(-40)
$snapdate = ""
########################################################


$viServer= $args[0]  

$user=”jjoseph”
$credentialFile=”C:\securestring.txt”
$pass = cat $credentialFile | convertto-securestring
$credentials = new-object -typename System.Management.Automation.PSCredential -argumentlist $user,$pass


$Report = @()

	if ($debug -eq "True"){
		$viServer = "goc1envvcr01v.pmint.pmihq.org"
		}



Connect-VIServer $viServer -credential $credentials 


$viDC = Get-Datacenter 
$SummSheet.range("A1:A1").cells=$viDC.Name
$SummRow = 2

$viClusters = Get-Cluster -Location $viDC
	foreach ($viCluster in $viClusters) {
		
		$TotalDiskUsed = 0
		$TotalClusMem = 0
		$TotalMemReserved = 0
		$TotalMemReservedPO = 0
		######################################Populate Resources Worksheet for each Cluster#################################3

		
		$worksheet = $workbook.sheets.add()
		$worksheet.name = "$viCluster-Resources"
		$worksheet.range("A1:A1").cells="VM Name"
		$worksheet.range("B1:B1").cells="Memory Allocation Reservation"
		$worksheet.range("C1:C1").cells="Memory Allocation Limit"
		$worksheet.range("E1:E1").cells="Number of Processors"
		$worksheet.range("D1:D1").cells="RAM Assigned"
		$worksheet.range("A1:H1").font.bold = $true
		$worksheet.range("F1:F1").cells="Tools Status"
		$worksheet.range("G1:G1").cells="Tools Version"
		$worksheet.range("H1:H1").cells="Notes"
		
		$i=2
		
		$viVMs = get-vm -Location $viCluster
		foreach ($viVM in $viVMs) {
			$vm = Get-View $viVM.ID
# 			if($vm.resourceconfig.memoryallocation.limit -ne -1){
		
			$Worksheet.range("A$i:A$i").cells= $vm.Name
			$Worksheet.range("B$i:B$i").cells= $vm.resourceconfig.memoryallocation.reservation
		
			
			$TotalMemReserved += $vm.ResourceConfig.MemoryAllocation.Reservation
			if ($viVM.PowerState -eq "PoweredOn"){
				$TotalMemReservedPO += $vm.ResourceConfig.MemoryAllocation.Reservation
				}
			
			if ($vm.ResourceConfig.MemoryAllocation.Limit -ne -1){
				$Worksheet.range("C$i:C$i").cells= $vm.resourceconfig.memoryallocation.limit
				}
			else {
				$worksheet.range("C$i:C$i").cells= "Unlimited"
				}		
			
			$Worksheet.range("E$i:E$i").cells= $vm.Summary.Config.NumCPU
			
			$Worksheet.range("D$i:D$i").cells= $vm.Summary.Config.MemorySizeMB
			
			
			
			if ($vm.Guest.ToolsStatus -eq 0){
				$toolsstatus = "Tools Not Installed"
				}
			if ($vm.Guest.ToolsStatus -eq 1){
				$toolsstatus = "Tools Not Running"
				}
			if ($vm.Guest.ToolsStatus -eq 2){
				$toolsstatus = "Tools Out of Date"
				}
			if ($vm.Guest.ToolsStatus -eq 3){
				$toolsstatus = "Tools OK"
				}
			$Worksheet.range("F$i:F$i").cells= $toolsstatus
			$Worksheet.range("G$i:G$i").cells= $vm.Guest.ToolsVersion
			$Worksheet.range("H$i:H$i").cells= $vm.Config.Annotation
			
			#########################  Highlighting Logic ####################################
			if ($vm.ResourceConfig.MemoryAllocation.Reservation -lt $vm.ResourceConfig.MemoryAllocation.Limit ){
				$Worksheet.range("A$i:H$i").Interior.colorindex = 45 			##Highlight in Orange
			}			
			if ($vm.ResourceConfig.MemoryAllocation.Limit -ne -1){
				if ($vm.ResourceConfig.MemoryAllocation.Limit -lt $vm.Summary.Config.MemorySizeMB){
					$Worksheet.range("A$i:H$i").Interior.colorindex = 44 			##Highlight in Yellow	
				}
			}
			##Orange if Reservation is less than limit
			##Yellow if MemoryLimit is less than Memory Allocated to Server
			
			
			
			##################################################################################
			
			
			$i++
			
    		$Report += $ReportRow
#  			}
			
		if ($debug -eq "True"){
			break
			}
	
		}
		$i++
		$lastrow=$i-1
		$worksheet.range("C$i:C$i").cells = "=sum(c2:c" + $lastrow + ")"
		$worksheet.range("B$i:C$i").cells = "=sum(b2:b" + $lastrow + ")"
		$worksheet.range("A$i:A$i").cells = "Total:"
		
		$worksheet.range('a:a').columnwidth = 35
		$worksheet.range('b:b').columnwidth = 8
		$worksheet.range('c:c').columnwidth = 8
		$worksheet.range('d:d').columnwidth = 8
		$worksheet.range('e:e').columnwidth = 8
		$worksheet.range('h:h').columnwidth = 75
		
			##Freeze Panes on Resources Sheet
			$excel.ActiveWindow.SplitColumn = 1
			$excel.ActiveWindow.SplitRow = 1
			$excel.ActiveWindow.FreezePanes = $true
		
			#####Legend###
			$Worksheet.range("A$i:A$i").cells= "Legend"
			$worksheet.range("A$i:A$i").font.bold = $true
			$i++
			$worksheet.Range("A$i:A$i").Interior.colorindex = 45
			$Worksheet.range("B$i:B$i").cells= "- Reservation is Lower than Limit"
			$i++
			$worksheet.Range("A$i:A$i").Interior.colorindex = 44
			$Worksheet.range("B$i:B$i").cells= "- Limit is lower than Allocated RAM"
		
				###############Populate VMDK Worksheet For Each Cluster####################################
		
		
		$worksheet = $workbook.sheets.add()
		$worksheet.name = "$viCluster-VMDK"
		$worksheet.range("A1:C1").font.bold = $true
		$worksheet.range("A1:A1").cells="VM Name"
		$worksheet.range("B1:B1").cells="File Name"
		$worksheet.range("C1:C1").cells="Size in GB"
		
		$i=2
		
		foreach ($viVM in $viVMs) {
			$vmHDs = Get-HardDisk $viVM
			foreach ($vmHD in $vmHDs){
			
			#$ReportRow = "" | Select-Object VMName, VMDK, VMDKSize
			$Worksheet.range("A$i:A$i").cells= $viVM.Name
			$Worksheet.range("B$i:B$i").cells= $vmHD.FileName
			$Worksheet.range("C$i:C$i").cells= $vmHD.CapacityKB/1024/1024
			$TotalDiskUsed += ($vmHD.CapacityKB/1024/1024)
    		$i++
    		}
			if ($debug -eq "True"){
			break
			}
		}
		$i++
		$lastrow=$i-1
		$worksheet.range("C$i:C$i").cells = "=sum(c2:c" + $lastrow + ")"
		$worksheet.range("A$i:A$i").cells = "Total:"
		
		$worksheet.range('a:a').columnwidth = 30
		$worksheet.range('b:b').columnwidth = 50
		$worksheet.range('c:c').columnwidth = 20
		
		

	
		
		#$Report | Export-Csv "$viCluster-Resouces.csv"
		$Report = @()
		
				###############Populate Snapshot Worksheet For Each Cluster####################################
		
		
		$worksheet = $workbook.sheets.add()
		$worksheet.name = "$viCluster-Snapshots"
		$worksheet.range("A1:A1").cells="VM Name"
		$worksheet.range("B1:B1").cells="Date Created"
		$worksheet.range("C1:C1").cells="Snapshot Name"
		$worksheet.range("A1:C1").font.bold = $true
		
		$i=2
		
		foreach ($viVM in $viVMs) {
			$vmSnaps = Get-Snapshot $viVM
			foreach ($vmSnap in $vmSnaps){
				if ($vmsnap.name -ne $null ){
					#$ReportRow = "" | Select-Object VMName, VMDK, VMDKSize
					$Worksheet.range("A$i:A$i").cells= $viVM.Name
					$Worksheet.range("B$i:B$i").cells= $vmSnap.Created
					$Worksheet.range("C$i:C$i").cells= $vmSnap.Name
					$snapdate = $vmSnap.Created | Get-Date
					if ($snapdate -lt $40daysago ){
						$worksheet.Range("A$i:C$i").Interior.colorindex = 44
						}
    				$i++
					}
    			}
			if ($debug -eq "True"){
			break
			}
		}
		$i++
		#$lastrow=$i-1
		#$worksheet.range("C$i:C$i").cells = "=sum(c2:c" + $lastrow + ")"
		#$worksheet.range("A$i:A$i").cells = "Total:"
		
		
		#$Report | Export-Csv "$viCluster-Resouces.csv"
		$Report = @()
		
		$worksheet.range('a:a').columnwidth = 30
		$worksheet.range('b:b').columnwidth = 15
		$worksheet.range('c:c').columnwidth = 50
		
			#####Legend###
			$Worksheet.range("A$i:A$i").cells= "Legend"
			$worksheet.range("A$i:A$i").font.bold = $true
			$i++
			$worksheet.Range("A$i:A$i").Interior.colorindex = 44
			$Worksheet.range("B$i:B$i").cells= "- Snapshot Older than 40 Days"
	

		#######################################Populate Summary Page for Cluster######################################3
		
		$SummSheet.range("B$SummRow:B$SummRow").cells= $viCluster.name
		$SummSheet.range("B$SummRow:B$SummRow").font.bold = $true
		$SummRow++
		
		$SummSheet.range("B$SummRow:B$SummRow").cells= "Total Memory Reserved (GB)"
		$SummSheet.range("C$SummRow:C$SummRow").cells= $TotalMemReserved/1024
		$SummRow++
		
		$SummSheet.range("B$SummRow:B$SummRow").cells= "Total Memory Reserved (Powered On) (GB)"
		$SummSheet.range("C$SummRow:C$SummRow").cells= $TotalMemReservedPO/1024
		$SummRow++
		
		$SummSheet.range("B$SummRow:B$SummRow").cells= "Total Memory in Cluster (GB)"
		$totalClusStats = $viCluster | Get-View
		$totalClusMem = $totalClusStats.Summary.TotalMemory/1Mb
		$SummSheet.range("C$SummRow:C$SummRow").cells= $TotalClusMem/1024
		if ($viCluster.Name -eq "Staging") {
			$SummSheet.range("D$SummRow:D$SummRow").cells= "309(GB) Guaranteed with Environment Project" }
		if ($viCluster.Name -eq "QA") {
			$SummSheet.range("D$SummRow:D$SummRow").cells= "154(GB) Guaranteed with Environment Project" }		
		if ($viCluster.Name -eq "Integration") {
			$SummSheet.range("D$SummRow:D$SummRow").cells= "179(GB) Guaranteed with Environment Project" }
		if ($viCluster.Name -eq "Development") {
			$SummSheet.range("D$SummRow:D$SummRow").cells= "136(GB) Guaranteed with Environment Project" }
		$SummRow++
	
		$SummSheet.range("B$SummRow:B$SummRow").cells= "Total Disk Used (GB)"
		$SummSheet.range("C$SummRow:C$SummRow").cells= $TotalDiskUsed
		if ($viCluster.Name -eq "Staging") {
			$SummSheet.range("D$SummRow:D$SummRow").cells= "14500(GB) Guaranteed with Environment Project" }
		if ($viCluster.Name -eq "QA") {
			$SummSheet.range("D$SummRow:D$SummRow").cells= "5500(GB) Guaranteed with Environment Project" }		
		if ($viCluster.Name -eq "Integration") {
			$SummSheet.range("D$SummRow:D$SummRow").cells= "10400(GB) Guaranteed with Environment Project" }
		if ($viCluster.Name -eq "Development") {
			$SummSheet.range("D$SummRow:D$SummRow").cells= "5100(GB) Guaranteed with Environment Project" }
		$SummRow++
		
		
		
		#$SummSheet.range("B$SummRow:B$SummRow").cells= "Total Number of Snapshots"
		#$SummSheet.range("C$SummRow:C$SummRow").cells= $TotalSnaps
		#$SummRow++
		$SummRow++
		
		
		
			if ($debug -eq "True"){
			break
			}
	}
	
# Set column Width
$SummSheet.range('a:a').columnwidth = 10
$SummSheet.range('b:b').columnwidth = 30
$SummSheet.range('c:c').columnwidth = 50


$output = "\VMscripts\jj-report\$viDC-Resources.xlsx"


$workbook.saveas("$output")
$excel.Quit()

Disconnect-VIServer -Confirm:$False









###################################################################################################
#                         Send E-mails 															  #
###################################################################################################
if ($debug -ne "True"){	


$SmtpClient = new-object system.net.mail.smtpClient 
$MailMessage = New-Object system.net.mail.mailmessage 
$att = new-object Net.Mail.Attachment($output)


$SmtpClient.Host = "172.19.0.151" 
$mailmessage.from = "deploycomplete@pmi.org" 

$mailmessage.To.add("_environmentteam@pmi.org") 
#$mailmessage.To.add("jim.joseph@pmi.org") 

$mailmessage.Subject = “VMware Utilization Report” +  $rundate 
$mailmessage.Body = "See the attached for details. Report Generated " + $rundate
#add an attachment
$mailmessage.Attachments.Add($att)
$mailmessage.Headers.Add("message-id", "<3BD50098E401463AA228377848493927-1>") 

 

 

$smtpclient.Send($mailmessage)



$att.Dispose()
}