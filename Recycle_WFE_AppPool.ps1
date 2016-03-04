$AppPool = "admin.pmi.org"
#Add-PSSnapin webadministration

$cred = Get-Credential

write-host $cred


$Session = New-PSSession -ComputerName "VCPINTWFE2.pmienvs.pmihq.org"  -Credential $cred
Invoke-Command -Session $Session -ScriptBlock { Add-PSSnapin webadministration ; start-webapppool $AppPool manageusers}

Exit
