#------WFE Application Pool Tools--------------------
# SYNTAX: 
# .\WFE-pools.ps1 [-pool 'name']
# 
# DESCRIPTION:
# This tool is for automating WFE Application Pool restarts
# This is dependent on the PMIENVIRONMENT variable on each system, if it is not correctly identified the script will stop.
# 
#---------------------------------------------------

#Switch Check
[cmdletbinding()]
param([string]$pool)

#DEFINE: DATA/ARRAYS/IMPORTS------------------------
Import-Module WebAdministration -ErrorAction SilentlyContinue 
#---------------------------------------------------

#DEFINE: VARIABLES/CONNECTIONS----------------------
$vENV=$Env:PMIENVIRONMENT
$ocean = gci iis:\apppools -Name
$x = 0
$applist = @{}
#---------------------------------------------------

#PROCESS: FUNCTIONS-------------------------------------
#
# FUNCTIONALITY:
#  + drainPool - Performs various actions
#
# DESCRIPTION:
#  + all     - Performs a mass recycle of app pools
#  + display - Displays all pools
#  + 'name'  - Validated and recycles an individual pool
#  + choose  - Displays pools and allows choice to recycle
#------------------------------------------------------- 
function drainPool () {
    if ($pool -eq "all"){
        foreach ($app in $ocean) {
            Restart-WebAppPool $app
            write-host "RECYCLED: $app"
            }
        }
        
    elseif ($pool -eq "display"){
        foreach ($app in $ocean){write-host $app}}
    
    elseif ($pool -eq "choose"){
        foreach ($app in $ocean){
            $x +=1
            $applist.add($x, $app)
            write-host "$x - $app"
            }
        $chosen = read-host "Enter ID to Reset"
        
        if ($chosen){
            foreach ($itm in $applist.GetEnumerator()){
                $nme = $itm.name
                $val = $itm.value
                if ($nme -eq $chosen){
                    Restart-WebAppPool $val
                    write-host "RECYCLED: $val"
                    }
                   }
    }
    else {
    write-host "Looking for $pool..."
        if ($ocean -match $pool) {
            Restart-WebAppPool $pool
            write-host "RECYCLED: $pool"
            }
        else {write-host "ABORTED: $pool does not exist in the list!"}
    }
    }
    }
#-------------------------------------------------------
drainPool