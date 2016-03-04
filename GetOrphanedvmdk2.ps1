#
# Purpose : List all orphaned vmdk on all datastores in all VC's
# Version : v1.0
# Author  : HJA van Bokhoven
# Change  : v1.1  2009.02.14  DE  angepasst an ESX 3.5, Email versenden und Filegrösse ausgeben

#Main

$strVC = "vsphere"			# Change to VirtualCenter
$OutputFile = (split-path -parent $MyInvocation.MyCommand.Path) + "\OrphanedVMDK.txt"
$logfile = ($MyInvocation.MyCommand.Definition).Replace(".ps1",".log")
$SMTPServer = "internalrelay.pmi.org"			# Change to a SMTP server in your environment
$mailfrom = "tom.diobilda@pmi.org"			# Change to email address you want emails to be coming from
$mailto = "tom.diobilda@pmi.org"				# Change to email address you would like to receive emails
$mailreplyto = "tom.diobilda@pmi.org"			# Change to email address you would like to reply emails


# bei Befehlen die mit "Run As" (auch Scheduler) gestartet werden, sind die Variablen
# APPDATA, HOMEDRIVE, HOMEPATH, HOMESHARE und LOGONSERVER nicht definiert (Bug in Windows)
if (!$env:appdata)
    {
    if (Test-Path "$env:userprofile\Application Data" )
	{
	$env:appdata = "$env:userprofile\Application Data"
	}
    }

$countOrphaned = 0

if ([System.IO.File]::Exists($OutputFile))
    {
    Remove-Item $OutputFile
    }

(Get-Date –f "yyyy-MM-dd HH:mm:ss") + "  Looking for Orphaned VMDK Files..." | Out-File $logfile -Append
Connect-VIServer $strVC
$arrUsedDisks = Get-VM | Get-HardDisk | %{$_.filename}
$arrUsedDisks += Get-VM | Get-Snapshot | Get-HardDisk | %{$_.filename}
$arrUsedDisks += Get-Template | Get-HardDisk | %{$_.filename}
$arrDS = Get-Datastore | Sort-Object
Foreach ($strDatastore in $arrDS)
	{
	$strDatastoreName = $strDatastore.name
	Write-Host $strDatastoreName
	$ds = Get-Datastore -Name $strDatastoreName | %{Get-View $_.Id}
	$fileQueryFlags = New-Object VMware.Vim.FileQueryFlags
	$fileQueryFlags.FileSize = $true
	$fileQueryFlags.FileType = $true
	$fileQueryFlags.Modification = $true
	$searchSpec = New-Object VMware.Vim.HostDatastoreBrowserSearchSpec
	$searchSpec.details = $fileQueryFlags
	$searchSpec.sortFoldersFirst = $true
	$dsBrowser = Get-View $ds.browser
	$rootPath = "["+$ds.summary.Name+"]"
	$searchResult = $dsBrowser.SearchDatastoreSubFolders($rootPath, $searchSpec)
	$myCol = @()
	foreach ($folder in $searchResult)
	    {
	    foreach ($fileResult in $folder.File)
		{
		$file = "" | select Name, FullPath
		$file.Name = $fileResult.Path
		$strFilename = $file.Name
		IF ($strFilename)
		    {
		    IF ($strFilename.Contains(".vmdk"))
			{
			IF (!$strFilename.Contains("-flat.vmdk"))
			    {
			    IF (!$strFilename.Contains("delta.vmdk"))
				{
				$strCheckfile = "*"+$file.Name+"*"
				IF ($arrUsedDisks -Like $strCheckfile)
				    {
				    }
				ELSE 
				    {
				    $countOrphaned++
				    IF ($countOrphaned -eq 1)
					{
					($body = "Location,Filename,Size (GB)") | Out-File $Outputfile
					}
				    $strOutput = $folder.FolderPath + "," + $strFilename + "," + ([Math]::Round($fileResult.FileSize/1gb,2))
				    $body += ("`n" + $strOutput)
				    $strOutput | Out-File $Outputfile -width 150 -Append
				    (Get-Date –f "yyyy-MM-dd HH:mm:ss") + "     " + $strOutput | Out-File $logfile -width 150 -Append
			 	    }
		     		}
			    }
			}
		    }
		}
	    }
	}
(Get-Date –f "yyyy-MM-dd HH:mm:ss") + "  Job's done (" + $countOrphaned + " Orphaned VMDKs Found)" | Out-File $logfile -Append
if ($countOrphaned -gt 0)
    {
    $SmtpClient = New-Object system.net.mail.smtpClient
    $SmtpClient.host = $SMTPServer
    $MailMessage = New-Object system.net.mail.mailmessage
    $MailMessage.from = $mailfrom
    $MailMessage.To.add($mailto)
    $MailMessage.replyto = $mailreplyto
    $MailMessage.IsBodyHtml = 0
    $MailMessage.Subject = "Info: VMware orphaned VMDKs"
    $MailMessage.Body = $body
    $SmtpClient.Send($MailMessage)
    }
Disconnect-VIServer -Confirm:$False
