#snapshot some servers
#Hans Bader
#Version 1.0
#This will snapshot the servers based on the prefix of the environments

$vmsTOSnapshot = " "

$snapShotText = " "

function displayDialog
{
#---- Lots of work just to get a dialog box

[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 

$objForm = New-Object System.Windows.Forms.Form 
$objForm.Text = "Super Snapshot Taker"
$objForm.Size = New-Object System.Drawing.Size(300,200) 
$objForm.StartPosition = "CenterScreen"

$objForm.KeyPreview = $True
$objForm.Add_KeyDown({if ($_.KeyCode -eq "Enter") 
    {$x=$objTextBox.Text
	$objForm.Close()
	}})
$objForm.Add_KeyDown({if ($_.KeyCode -eq "Escape") 
    {$objForm.Close()
   
	}} )

$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Location = New-Object System.Drawing.Size(75,120)
$OKButton.Size = New-Object System.Drawing.Size(75,23)
$OKButton.Text = "OK"
$OKButton.Add_Click({$x=$objTextBox.Text;$objForm.Close()})
$objForm.Controls.Add($OKButton)

$CancelButton = New-Object System.Windows.Forms.Button
$CancelButton.Location = New-Object System.Drawing.Size(150,120)
$CancelButton.Size = New-Object System.Drawing.Size(75,23)
$CancelButton.Text = "Cancel"
$CancelButton.Add_Click({$objForm.Close()})
$objForm.Controls.Add($CancelButton)

$objLabel = New-Object System.Windows.Forms.Label
$objLabel.Location = New-Object System.Drawing.Size(10,20) 
$objLabel.Size = New-Object System.Drawing.Size(280,20) 
$objLabel.Text = "Enter the prefix or name of the VMs to snap shot:"

$objForm.Controls.Add($objLabel) 

$objTextBox = New-Object System.Windows.Forms.TextBox 
$objTextBox.Location = New-Object System.Drawing.Size(10,40) 
$objTextBox.Size = New-Object System.Drawing.Size(260,20)

$objLabel2 = New-Object System.Windows.Forms.Label
$objLabel2.Location = New-Object System.Drawing.Size(10,70) 
$objLabel2.Size = New-Object System.Drawing.Size(280,20) 
$objLabel2.Text = "Enter descriptive text for the snapshot(s):"

$objForm.Controls.Add($objLabel2) 

$objTextBox2 = New-Object System.Windows.Forms.TextBox 
$objTextBox2.Location = New-Object System.Drawing.Size(10,90) 
$objTextBox2.Size = New-Object System.Drawing.Size(260,20)



$objForm.Controls.Add($objTextBox)
$objForm.Controls.Add($objTextBox2)

$objForm.Topmost = $True

$objForm.Add_Shown({$objForm.Activate()})
[void] $objForm.ShowDialog()

if ($objForm.ActiveControl.Text -eq "Cancel")
{ "The button is cancel"

exit

}

	$x
	$vmsTOSnapshot = $objTextBox.Text + "*"
	$y
	$snapShotText = $objTextBox2.Text

$snapsTaken=takesnaps $vmsTOSnapshot $snapShotText 
}

#this will display the dialog box to select the file names

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




function takeSnaps([string]$vmsToSnapshot, [string]$snapShotText) 
{
Write-Output "The vms to grab are " + $vmsToSnapshot
Write-output "The extra text is " + $snapShotText

	#ADD VMWARE PSSNAPIN
	Add-PSSnapin -Name "VMware.VimAutomation.Core"
	
	#FORCE TO LOAD VMWARE POWERSHELL PLUGIN
	
	[Reflection.Assembly]::LoadWithPartialName("vmware.vim")
	
	#ON ERROR CONTINUE
	$ErrorActionPreference = "Stop"
	
	#----------------------------------------------------------
	#STATIC VARIABLES
	#----------------------------------------------------------
	$vcserver = "goc1envvcr01v.pmint.pmihq.org"
	
	
	#connect to VirtualCenter with credentials
	connect-viserver -server $vcserver 
	
	$Now = Get-Date
	
	#get all your moss servers
	$VMs = get-vm |where{$_.name -like $vmsToSnapshot}
	foreach ($vm in $VMs)
	#Take snapshots for each VM Box
	{
			$snappshotinfo = $snapShotText + " " + $now
			new-snapshot -vm $vm -name $snappshotinfo -Quiesce 
	} 

takeSnaps="Done"

}



$dialogs = displayDialog


#	$vmsTOSnapshot 

#	$snapShotText


#$snapsTaken=takesnaps
