Set-ExecutionPolicy Unrestricted -Force
import-module -name ADRMS
import-module -name AppLocker
import-module -name BitsTransfer
import-module -name BestPractices
import-module -name PSDiagnostics
import-module -name ServerManager
import-module -name TroubleshootingPack
import-module -name WebAdministration

## Create securitysvc.pmi.org site

new-webapppool -name "securitysvc.pmi.org"

mkdir c:\inetpub\wwwroot\securitysvc.pmi.org

new-website -Name "securitysvc.pmi.org" -PhysicalPath c:\inetpub\wwwroot\securitysvc.pmi.org -ApplicationPool "securitysvc.pmi.org" -Id 5018

remove-webbinding -Name "securitysvc.pmi.org" -Port 80

new-webbinding -Name "securitysvc.pmi.org" -Port 443 -HostHeader "securitysvc.pmi.org" -Protocol "https"

Set-ItemProperty iis:\apppools\securitysvc.pmi.org -name managedRuntimeVersion -value "v4.0"

Start-WebSite -Name "securitysvc.pmi.org"