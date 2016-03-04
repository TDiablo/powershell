Set-ExecutionPolicy Unrestricted -Force
import-module -name ADRMS
import-module -name AppLocker
import-module -name BitsTransfer
import-module -name BestPractices
import-module -name PSDiagnostics
import-module -name ServerManager
import-module -name TroubleshootingPack
import-module -name WebAdministration

## Create myadmin.pmi.org site

new-webapppool -name "myadmin.pmi.org"

mkdir c:\inetpub\wwwroot\myadmin.pmi.org

new-website -Name "myadmin.pmi.org" -PhysicalPath c:\inetpub\wwwroot\myadmin.pmi.org -ApplicationPool "myadmin.pmi.org" -Id 2022

new-webbinding -Name "myadmin.pmi.org" -Port 80 -HostHeader "myadmin.pmi.org"

new-webbinding -Name "myadmin.pmi.org" -Port 443 -HostHeader "myadmin.pmi.org" -Protocol "https"

Set-ItemProperty iis:\apppools\myadmin.pmi.org -name processModel -value @{userName="global\wfeuser1";password="C0ckSp!t";identitytype=3}

Set-ItemProperty iis:\apppools\myadmin.pmi.org -name managedPipelineMode -value 1

Start-WebSite -Name "myadmin.pmi.org"