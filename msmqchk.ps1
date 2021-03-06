#------API MSMQ Checker----------------------
# SYNTAX: 
# .\MSMQCHK.ps1
# 
# DESCRIPTION:
# This tool will poll for the MSMQ Count.  If it is over 100k send an alert out and restart the faulty service
# This will check both the PMI WCF ServiceHosts and AuditProcessorService which are known culprits of high counts
# 
# DEBUGGING:
# + Show MSMQ List
#   gwmi -class Win32_PerfRawData_MSMQ_MSMQQueue | Where-Object -FilterScript {$_.Name -like "*logrequest*"}
#---------------------------------------------------

#------DEFINE: VARIABLES---------------------------
$QThreshold = 100000
$PMISvcs = "PMI WCFServiceHost","PMI WCFServiceHost4.0","Pmi.AuditProcessorService"
$QCount = (gwmi -class Win32_PerfRawData_MSMQ_MSMQQueue | Where-Object -FilterScript {$_.Name -like "*logrequest*"} | foreach {(($_.MessagesinQueue -replace "\s+",","))})

#EMAIL SETUP
$PSEmailServer = "internalrelay.pmi.org"
$xFrm = "MSMQAlert@pmi.org"
$xTo = "_applicationsupport@pmi.org"
$xSub = "MSMQ Alert - [$env:computername]"
$xBod = ""
#--------------------------------------------------
clear

#------DEFINE: FUNCTIONS--------------------------
function sendAlert(){Send-MailMessage -From $xFrm -To $xTo -Subject $xSub -Body $xBod}
#--------------------------------------------------
if ($QCount -ge $QThreshold){
    echo "Alert Sent: Message Queue is at $QCount and is above threshold"
    $xBod = "NOTICE: [$env:computername] MSMQ reporting a count of $QCount over the 100k threshold; auto recovery in progress..."
    sendAlert
    foreach ($svc in $PMISvcs){
        echo "Restart $svc..."
        restart-service -name $svc -force
     }
}