$Session = New-PSSession -ComputerName QPROVA02
Invoke-Command -Session $Session -ScriptBlock { Add-PSSnapin webadministration ; start-webapppool manageusers }
