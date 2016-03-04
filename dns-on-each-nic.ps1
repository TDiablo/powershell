# Get the DNS Servers on each NIC

$serverlist = Import-CSV ..\RackspaceServerList\RackspaceServerList.csv

Write-Host "----------------------"
foreach( $server in $serverlist ){
	$serverName = $server.Name
	$serverType = $server.Type
	$serverPower = $server.Power
	
	Write-Host "SERVER: $serverName TYPE: $serverType"
	if( $serverType -eq "LINUX" -or $serverPower -eq "OFF" -or $serverPower -eq "SKIP") {
		Write-Host "Skipping $serverName since it's either LINUX or OFF or marked SKIP."
	} else {
	
		#Test-Connection $serverName
		$nics = get-wmiobject -class win32_networkadapterconfiguration -computername $serverName -filter IPEnabled=TRUE | select name, DNSServerSearchOrder
		
		$x = 1
		foreach( $nic in $nics ){
		
			if( $nic.DNSServerSearchOrder -ne $null ){

				$y = 1
				foreach ( $dnserver in $nic.DNSServerSearchOrder ){
					Write-Host "NIC #$x DNS #$y is $dnserver"
					$y++
				}
			}
			
			$x++
		}
	}
	
	Write-Host "----------------------"
}
