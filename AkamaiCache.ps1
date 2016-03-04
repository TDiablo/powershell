#--------------------
# v1.0 AKAMAICACHE
#------------[gzenhye]
#
# This script fires off a REST call to Akamai to clear the Cache or CP Code
#
# SYNTAX:
# AkamaiCache -Action -Domain -EmailNotification -Type -Resource -Username -Password
#------------------------------------------------------------------------------------
# 	Action:		String 	"Remove" (Purge Content) or "Invalidate" (Expire Content)
#	Domain: 	String	"Production" or "Staging"
#	Email:		Array	"Email Address1,Email Address2..."
#	Type:		String	"ARL" (URLs) or "CPCode" (Full Site Reset)
#	Resource:	Array	ARLs or CPCodes
#------------------------------------------------------------------------------------
# Notes:
# API Document: https://api.ccu.akamai.com/ccu/v2/docs/index.html
#
# Common ARLs:
# 	http://www.pmi.org
#
# CP Codes:
#	329987 - Site Accelerator   349530 - www.projectmanagement.com   
# 	356783 - static.pmi.org   	365824 - dev.projectmanagement.com   

Function Clear-AkamaiCache
{
 [CmdletBinding()]
 Param(
 [ValidateSet("invalidate","remove")]
 [ValidateNotNullOrEmpty()]
 [string]$Action,
 [ValidateSet("staging","production")]
 [ValidateNotNullOrEmpty()]
 [string]$Domain,
 [ValidateSet("arl","cpcode")]
 [ValidateNotNullOrEmpty()]
 [string]$Type,
 [ValidateNotNullOrEmpty()]
 [string]$username,
 [ValidateNotNullOrEmpty()]
 [string]$password,
 [ValidateNotNullOrEmpty()]
 [String[]]$Resource
 )
 
 $AkamaiRESTUrl = "https://api.ccu.akamai.com/ccu/v2/queues/default"
 
 $options = @{}
 
 Write-Verbose "Create Action String..."
 $options.Add("action",$Action.ToLower())
 $options.Add("domain",$Domain.ToLower())
 $options.Add("type",$Type.ToLower())
 $options.Add("objects",$Resource)
 
 Write-Verbose "Sending JSON to Server..."
 $body = ConvertTo-Json -InputObject $options
 $cred = new-object -TypeName System.Management.Automation.PSCredential -ArgumentList $username, $(ConvertTo-SecureString -String $password -AsPlainText -Force)
 $result = Invoke-RestMethod -Method Post -Uri $AkamaiRESTUrl -Credential $cred -ContentType "application/json" -Body $body
 $properties = @{}
 $result.psobject.properties | ForEach-Object {$properties.Add($_.Name, $_.Value)}
 $properties.Add("Credential", $cred)
 Write-Output (new-object -TypeName PSObject -Property $properties)
}
 
Function Get-AkamaiStatus
{
 [CmdletBinding()]
 Param(
 [Parameter(
 ValueFromPipeline=$true)]
 [PSObject]$PurgeResponseObject
 )
 
 if ($PurgeResponseObject.httpStatus -ne "201")
 {
 $PurgeResponseObject | select httpStatus, detail, purgeId, supportId
 Write-Error "** REQUEST FAILED: SEE ABOVE FOR DETAILS **"
 return
 }
 
 $job = Start-Job -Name "GetAkamaiStatus" -ArgumentList $PurgeResponseObject -ScriptBlock {
 $obj = $args[0]
 $akamaiUrl = "https://api.ccu.akamai.com"
 $progressUrl = $akamaiUrl + $obj.progressUri
 Start-Sleep -Seconds $($obj.pingAfterSeconds)
 Invoke-RestMethod -Uri $progressUrl -Credential $obj.Credential
 }
 
 Register-ObjectEvent $job -EventName StateChanged -Action {
 Write-Host ('Job #{0} ({1}) complete.' -f $sender.Id, $sender.Name)
 Write-Host 'Use this command to rectrieve the result.'
 Write-Host (prompt) -NoNewline
 Write-Host ('Receive-Job -ID {0}; Remove-Job -ID {0}' -f $sender.Id)
 Write-Host (prompt) -NoNewline
 $eventSubscriber | Unregister-Event
 $eventSubscriber.Action | Remove-Job
 } | Out-Null
}