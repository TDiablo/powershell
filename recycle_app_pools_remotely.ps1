#*********************************************
# This script recycles every app pool in $apppoollist
# for each server in $serverlist
#
# This is a modification of the script found in:
# http://serverfault.com/questions/223496/recycle-remote-iis-app-pool-from-the-command-line
#*********************************************

WRITE-HOST "Start - APP POOL RECYCLING Script"

$serverlist = @("VCPINTWFE2.pmienvs.pmihq.org","INTWFE1.pmienvs.pmihq.org")
$apppoollist=@("my.pmi.org","admin.pmi.org")
$resultlist=@("The following was done: ")

foreach( $server in $serverlist ){
    ## LIST all the app pools for server, note the __RELPATH of the one you want to kill.
    ## It displays lots of info here. It's really annoying and needs to be surpressed somehow.
    Get-WMIObject IISApplicationPool -Computer $server -Namespace root\MicrosoftIISv2 -Authentication PacketPrivacy 

    foreach ( $apppool in $apppoollist ){
        ## Recycle a specific app pool:
        $Name = "W3SVC/APPPOOLS/$apppool"  ## This is the Name from above
        $Path = "IISApplicationPool.Name='$Name'"      ## This is the __RELPATH

        WRITE-HOST "*******************************"
        WRITE-HOST "Recycling App Pool $apppool on $server"
        Invoke-WMIMethod Recycle -Path $Path -Computer $server -Namespace root\MicrosoftIISv2 -Authentication PacketPrivacy
        
        #Add the action to the results list for printing to screen when script is done
        $resultlist = $resultlist + "Recycled App Pool $apppool on $server"
        WRITE-HOST "******************************* `n"
    }
}

#Insert blank line for shits and giggles
WRITE-HOST "`n"

#Display the results for that warm fuzzy feeling
foreach ($line in $resultlist){ WRITE-HOST $line }

WRITE-HOST "END - APP POOL RECYCLING Script"