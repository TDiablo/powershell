## Create qs.pmi.org site

remove-webapppool -name "qs.pmi.org"

new-webapppool -name "qs.pmi.org"

rmdir -recurse c:\inetpub\wwwroot\qs.pmi.org

mkdir c:\inetpub\wwwroot\qs.pmi.org

remove-website -Name "qs.pmi.org"

new-website -Name "qs.pmi.org" -PhysicalPath c:\inetpub\wwwroot\qs.pmi.org -ApplicationPool "qs.pmi.org" -Id 5000

remove-webbinding -Name "qs.pmi.org" -Port 80

new-webbinding -Name "qs.pmi.org" -Port 80 -HostHeader "qs.candidate.pmi.org"


## Create ses.pmi.org site

remove-webapppool -name "ses.pmi.org"

new-webapppool -name "ses.pmi.org"

rmdir -recurse c:\inetpub\wwwroot\ses.pmi.org

mkdir c:\inetpub\wwwroot\ses.pmi.org

remove-website -Name "ses.pmi.org"

new-website -Name "ses.pmi.org" -PhysicalPath c:\inetpub\wwwroot\ses.pmi.org -ApplicationPool "ses.pmi.org" -Id 5001

remove-webbinding -Name "ses.pmi.org" -Port 80

new-webbinding -Name "ses.pmi.org" -Port 80 -HostHeader "ses.candidate.pmi.org"


## Create svc.pmi.org site

remove-webapppool -name "svc.pmi.org"

new-webapppool -name "svc.pmi.org"

rmdir -recurse c:\inetpub\wwwroot\svc.pmi.org

mkdir c:\inetpub\wwwroot\svc.pmi.org

remove-website -Name "svc.pmi.org"

new-website -Name "svc.pmi.org" -PhysicalPath c:\inetpub\wwwroot\svc.pmi.org -ApplicationPool "svc.pmi.org" -Id 5002

remove-webbinding -Name "svc.pmi.org" -Port 80 

new-webbinding -Name "svc.pmi.org" -Port 80 -HostHeader "svc.candidate.pmi.org"

new-webbinding -Name "svc.pmi.org" -Port 443 -HostHeader "svc.candidate.pmi.org" -Protocol "https"


## Create svc.pmi.org-DEPServices site

remove-webapppool -name "svc.pmi.org-DEPServices"

new-webapppool -name "svc.pmi.org-DEPServices"

rmdir -recurse c:\inetpub\wwwroot\svc.pmi.org-DEPServices

mkdir c:\inetpub\wwwroot\svc.pmi.org-DEPServices

new-webvirtualdirectory -Site "svc.pmi.org" -Name DEPServices -PhysicalPath c:\inetpub\wwwroot\svc.pmi.org-DEPServices

convertto-WebApplication -ApplicationPool "svc.pmi.org-DEPServices" "iis:\sites\svc.pmi.org\DEPServices"


## Create svc.pmi.org-MarketplaceServices site

remove-webapppool -name "svc.pmi.org-MarketplaceServices"

new-webapppool -name "svc.pmi.org-MarketplaceServices"

Set-ItemProperty iis:\apppools\svc.pmi.org-MarketplaceServices -name processModel -value @{userName="Network Service";identitytype=3}

Set-ItemProperty iis:\apppools\svc.pmi.org-MarketplaceServices -name managedPipelineMode -value 1

rmdir -recurse c:\inetpub\wwwroot\svc.pmi.org-MarketplaceServices

mkdir c:\inetpub\wwwroot\svc.pmi.org-MarketplaceServices

new-webvirtualdirectory -Site "svc.pmi.org" -Name MarketplaceServices -PhysicalPath c:\inetpub\wwwroot\svc.pmi.org-MarketplaceServices

convertto-WebApplication -ApplicationPool "svc.pmi.org-MarketplaceServices" "iis:\sites\svc.pmi.org\MarketplaceServices"


## Create svc.pmi.org-Taxes site

remove-webapppool -name "svc.pmi.org-Taxes"

new-webapppool -name "svc.pmi.org-Taxes"

Set-ItemProperty iis:\apppools\svc.pmi.org-Taxes -name processModel -value @{userName="pmienvs\canapiuser";password="P@55w*rd";identitytype=3}

Set-ItemProperty iis:\apppools\svc.pmi.org-Taxes -name managedPipelineMode -value 1

rmdir -recurse c:\inetpub\wwwroot\svc.pmi.org-Taxes

mkdir c:\inetpub\wwwroot\svc.pmi.org-Taxes

new-webvirtualdirectory -Site "svc.pmi.org" -Name Taxes -PhysicalPath c:\inetpub\wwwroot\svc.pmi.org-Taxes

convertto-WebApplication -ApplicationPool "svc.pmi.org-Taxes" "iis:\sites\svc.pmi.org\Taxes"


## Create authenticationsvc.pmi.org site

remove-webapppool -name "authenticationsvc.pmi.org"

new-webapppool -name "authenticationsvc.pmi.org"

Set-ItemProperty iis:\apppools\authenticationsvc.pmi.org -name managedRuntimeVersion -value "v4.0"

rmdir -recurse c:\inetpub\wwwroot\authenticationsvc.pmi.org

mkdir c:\inetpub\wwwroot\authenticationsvc.pmi.org

remove-website -Name "authenticationsvc.pmi.org"

new-website -Name "authenticationsvc.pmi.org" -PhysicalPath c:\inetpub\wwwroot\authenticationsvc.pmi.org -ApplicationPool "authenticationsvc.pmi.org" -Id 5005

remove-webbinding -Name "authenticationsvc.pmi.org" -Port 80

new-webbinding -Name "authenticationsvc.pmi.org" -Port 80 -HostHeader "authenticationsvc.candidate.pmi.org"

new-webbinding -Name "authenticationsvc.pmi.org" -Port 443 -HostHeader "authenticationsvc.candidate.pmi.org" -Protocol "https"


## Create certificationsvc.pmi.org site

remove-webapppool -name "certificationsvc.pmi.org"

new-webapppool -name "certificationsvc.pmi.org"

Set-ItemProperty iis:\apppools\certificationsvc.pmi.org -name managedRuntimeVersion -value "v4.0"

rmdir -recurse c:\inetpub\wwwroot\certificationsvc.pmi.org

mkdir c:\inetpub\wwwroot\certificationsvc.pmi.org

remove-website -Name "certificationsvc.pmi.org"

new-website -Name "certificationsvc.pmi.org" -PhysicalPath c:\inetpub\wwwroot\certificationsvc.pmi.org -ApplicationPool "certificationsvc.pmi.org" -Id 5006

remove-webbinding -Name "certificationsvc.pmi.org" -Port 80

new-webbinding -Name "certificationsvc.pmi.org" -Port 443 -HostHeader "certificationsvc.candidate.pmi.org" -Protocol "https"


## Create membershipsvc.pmi.org site

remove-webapppool -name "membershipsvc.pmi.org"

new-webapppool -name "membershipsvc.pmi.org"

Set-ItemProperty iis:\apppools\membershipsvc.pmi.org -name managedRuntimeVersion -value "v4.0"

rmdir -recurse c:\inetpub\wwwroot\membershipsvc.pmi.org

mkdir c:\inetpub\wwwroot\membershipsvc.pmi.org

remove-website -Name "membershipsvc.pmi.org"

new-website -Name "membershipsvc.pmi.org" -PhysicalPath c:\inetpub\wwwroot\membershipsvc.pmi.org -ApplicationPool "membershipsvc.pmi.org" -Id 5007

remove-webbinding -Name "membershipsvc.pmi.org" -Port 80

new-webbinding -Name "membershipsvc.pmi.org" -Port 443 -HostHeader "membershipsvc.candidate.pmi.org" -Protocol "https"


## Create profilesvc.pmi.org site

remove-webapppool -name "profilesvc.pmi.org"

new-webapppool -name "profilesvc.pmi.org"

Set-ItemProperty iis:\apppools\profilesvc.pmi.org -name processModel -value @{userName="pmienvs\canapiuser";password="P@55w*rd";identitytype=3}

Set-ItemProperty iis:\apppools\profilesvc.pmi.org -name managedRuntimeVersion -value "v4.0"

rmdir -recurse c:\inetpub\wwwroot\profilesvc.pmi.org

mkdir c:\inetpub\wwwroot\profilesvc.pmi.org

remove-website -Name "profilesvc.pmi.org"

new-website -Name "profilesvc.pmi.org" -PhysicalPath c:\inetpub\wwwroot\profilesvc.pmi.org -ApplicationPool "profilesvc.pmi.org" -Id 5008

remove-webbinding -Name "profilesvc.pmi.org" -Port 80

new-webbinding -Name "profilesvc.pmi.org" -Port 443 -HostHeader "profilesvc.candidate.pmi.org" -Protocol "https"


## Create searchsvc.pmi.org site

remove-webapppool -name "searchsvc.pmi.org"

new-webapppool -name "searchsvc.pmi.org"

Set-ItemProperty iis:\apppools\searchsvc.pmi.org -name managedRuntimeVersion -value "v4.0"

rmdir -recurse c:\inetpub\wwwroot\searchsvc.pmi.org

mkdir c:\inetpub\wwwroot\searchsvc.pmi.org

remove-website -Name "searchsvc.pmi.org"

new-website -Name "searchsvc.pmi.org" -PhysicalPath c:\inetpub\wwwroot\searchsvc.pmi.org -ApplicationPool "searchsvc.pmi.org" -Id 5009

remove-webbinding -Name "searchsvc.pmi.org" -Port 80

new-webbinding -Name "searchsvc.pmi.org" -Port 443 -HostHeader "searchsvc.candidate.pmi.org" -Protocol "https"


## Create datasvc.pmi.org site

remove-webapppool -name "datasvc.pmi.org"

new-webapppool -name "datasvc.pmi.org"

Set-ItemProperty iis:\apppools\datasvc.pmi.org -name processModel -value @{userName="pmienvs\canapiuser";password="P@55w*rd";identitytype=3}

Set-ItemProperty iis:\apppools\datasvc.pmi.org -name managedRuntimeVersion -value "v4.0"

rmdir -recurse c:\inetpub\wwwroot\datasvc.pmi.org

mkdir c:\inetpub\wwwroot\datasvc.pmi.org

remove-website -Name "datasvc.pmi.org"

new-website -Name "datasvc.pmi.org" -PhysicalPath c:\inetpub\wwwroot\datasvc.pmi.org -ApplicationPool "datasvc.pmi.org" -Id 5010

remove-webbinding -Name "datasvc.pmi.org" -Port 80

new-webbinding -Name "datasvc.pmi.org" -Port 443 -HostHeader "datasvc.candidate.pmi.org" -Protocol "https"


## Create utilitysvc.pmi.org site

remove-webapppool -name "utilitysvc.pmi.org"

new-webapppool -name "utilitysvc.pmi.org"

Set-ItemProperty iis:\apppools\utilitysvc.pmi.org -name managedRuntimeVersion -value "v4.0"

rmdir -recurse c:\inetpub\wwwroot\utilitysvc.pmi.org

mkdir c:\inetpub\wwwroot\utilitysvc.pmi.org

remove-website -Name "utilitysvc.pmi.org"

new-website -Name "utilitysvc.pmi.org" -PhysicalPath c:\inetpub\wwwroot\utilitysvc.pmi.org -ApplicationPool "utilitysvc.pmi.org" -Id 5011

remove-webbinding -Name "utilitysvc.pmi.org" -Port 80

new-webbinding -Name "utilitysvc.pmi.org" -Port 80 -HostHeader "utilitysvc.candidate.pmi.org"

new-webbinding -Name "utilitysvc.pmi.org" -Port 443 -HostHeader "utilitysvc.candidate.pmi.org" -Protocol "https"


## Create api.pmi.org site

remove-webapppool -name "api.pmi.org"

new-webapppool -name "api.pmi.org"

Set-ItemProperty iis:\apppools\www.pmi.org -name managedPipelineMode -value 1

rmdir -recurse c:\inetpub\wwwroot\api.pmi.org

mkdir c:\inetpub\wwwroot\api.pmi.org

remove-website -Name "api.pmi.org"

new-website -Name "api.pmi.org" -PhysicalPath c:\inetpub\wwwroot\api.pmi.org -ApplicationPool "api.pmi.org" -Id 5012

remove-webbinding -Name "api.pmi.org" -Port 80

new-webbinding -Name "api.pmi.org" -Port 80 -HostHeader "api.candidate.pmi.org"

new-webbinding -Name "api.pmi.org" -Port 443 -HostHeader "api.candidate.pmi.org" -Protocol "https"


## Create services.pmi.org site

remove-webapppool -name "services.pmi.org"

new-webapppool -name "services.pmi.org"

rmdir -recurse c:\inetpub\wwwroot\services.pmi.org

mkdir c:\inetpub\wwwroot\services.pmi.org

remove-website -Name "services.pmi.org"

new-website -Name "services.pmi.org" -PhysicalPath c:\inetpub\wwwroot\services.pmi.org -ApplicationPool "services.pmi.org" -Id 5013

remove-webbinding -Name "services.pmi.org" -Port 80

new-webbinding -Name "services.pmi.org" -Port 8080 -HostHeader "services.candidate.pmi.org"

new-webbinding -Name "services.pmi.org" -Port 443 -HostHeader "services.candidate.pmi.org" -Protocol "https"


## Create volunteerinfosvc.pmi.org site

remove-webapppool -name "volunteerinfosvc.pmi.org"

new-webapppool -name "volunteerinfosvc.pmi.org"

Set-ItemProperty iis:\apppools\volunteerinfosvc.pmi.org -name processModel -value @{userName="pmienvs\canapiuser";password="P@55w*rd";identitytype=3}

rmdir -recurse c:\inetpub\wwwroot\volunteerinfosvc.pmi.org

mkdir c:\inetpub\wwwroot\volunteerinfosvc.pmi.org

remove-website -Name "volunteerinfosvc.pmi.org"

new-website -Name "volunteerinfosvc.pmi.org" -PhysicalPath c:\inetpub\wwwroot\volunteerinfosvc.pmi.org -ApplicationPool "volunteerinfosvc.pmi.org" -Id 5014

remove-webbinding -Name "volunteerinfosvc.pmi.org" -Port 80

new-webbinding -Name "volunteerinfosvc.pmi.org" -Port 80 -HostHeader "volunteerinfosvc.candidate.pmi.org"

new-webbinding -Name "volunteerinfosvc.pmi.org" -Port 443 -HostHeader "volunteerinfosvc.candidate.pmi.org" -Protocol "https"


## Create eventsvc.pmi.org site

remove-webapppool -name "eventsvc.pmi.org"

new-webapppool -name "eventsvc.pmi.org"

Set-ItemProperty iis:\apppools\eventsvc.pmi.org -name managedRuntimeVersion -value "v4.0"

rmdir -recurse c:\inetpub\wwwroot\eventsvc.pmi.org

mkdir c:\inetpub\wwwroot\eventsvc.pmi.org

remove-website -Name "eventsvc.pmi.org"

new-website -Name "eventsvc.pmi.org" -PhysicalPath c:\inetpub\wwwroot\eventsvc.pmi.org -ApplicationPool "eventsvc.pmi.org" -Id 5015

remove-webbinding -Name "eventsvc.pmi.org" -Port 80

new-webbinding -Name "eventsvc.pmi.org" -Port 80 -HostHeader "eventsvc.candidate.pmi.org"

new-webbinding -Name "eventsvc.pmi.org" -Port 443 -HostHeader "eventsvc.candidate.pmi.org" -Protocol "https"