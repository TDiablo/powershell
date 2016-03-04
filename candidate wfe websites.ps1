## Create authentication.pmi.org site

remove-webapppool -name "authentication.pmi.org"

new-webapppool -name "authentication.pmi.org"

rmdir -recurse c:\inetpub\wwwroot\authentication.pmi.org

mkdir c:\inetpub\wwwroot\authentication.pmi.org

remove-website -Name "authentication.pmi.org"

new-website -Name "authentication.pmi.org" -PhysicalPath c:\inetpub\wwwroot\authentication.pmi.org -ApplicationPool "authentication.pmi.org" -Id 2000

remove-webbinding -Name "authentication.pmi.org" -Port 80

new-webbinding -Name "authentication.pmi.org" -Port 80 -HostHeader "authentication.candidate.pmi.org"

new-webbinding -Name "authentication.pmi.org" -Port 443 -HostHeader "authentication.candidate.pmi.org" -Protocol "https"


## Create ccrs.pmi.org site

remove-webapppool -name "ccrs.pmi.org"

new-webapppool -name "ccrs.pmi.org"

rmdir -recurse c:\inetpub\wwwroot\ccrs.pmi.org

mkdir c:\inetpub\wwwroot\ccrs.pmi.org

remove-website -Name "ccrs.pmi.org"

new-website -Name "ccrs.pmi.org" -PhysicalPath c:\inetpub\wwwroot\ccrs.pmi.org -ApplicationPool "ccrs.pmi.org" -Id 2001

remove-webbinding -Name "ccrs.pmi.org" -Port 80 

new-webbinding -Name "ccrs.pmi.org" -Port 80 -HostHeader "ccrs.candidate.pmi.org"

new-webbinding -Name "ccrs.pmi.org" -Port 443 -HostHeader "ccrs.candidate.pmi.org" -Protocol "https"




## Create certification.pmi.org site

remove-webapppool -name "certification.pmi.org"

new-webapppool -name "certification.pmi.org"

rmdir -recurse c:\inetpub\wwwroot\certification.pmi.org

mkdir c:\inetpub\wwwroot\certification.pmi.org

remove-website -Name "certification.pmi.org"

new-website -Name "certification.pmi.org" -PhysicalPath c:\inetpub\wwwroot\certification.pmi.org -ApplicationPool "certification.pmi.org" -Id 2002

remove-webbinding -Name "certification.pmi.org" -Port 80

new-webbinding -Name "certification.pmi.org" -Port 80 -HostHeader "certification.candidate.pmi.org"

new-webbinding -Name "certification.pmi.org" -Port 443 -HostHeader "certification.candidate.pmi.org" -Protocol "https"


## Create components.pmi.org site

remove-webapppool -name "components.pmi.org"

new-webapppool -name "components.pmi.org"

rmdir -recurse c:\inetpub\wwwroot\components.pmi.org

mkdir c:\inetpub\wwwroot\components.pmi.org

remove-website -Name "components.pmi.org"

new-website -Name "components.pmi.org" -PhysicalPath c:\inetpub\wwwroot\components.pmi.org -ApplicationPool "components.pmi.org" -Id 2003

remove-webbinding -Name "components.pmi.org" -Port 80

new-webbinding -Name "components.pmi.org" -Port 80 -HostHeader "components.candidate.pmi.org"

new-webbinding -Name "components.pmi.org" -Port 443 -HostHeader "components.candidate.pmi.org" -Protocol "https"


## Create drm.pmi.org site

remove-webapppool -name "drm.pmi.org"

new-webapppool -name "drm.pmi.org"

rmdir -recurse c:\inetpub\wwwroot\drm.pmi.org

mkdir c:\inetpub\wwwroot\drm.pmi.org

remove-website -Name "drm.pmi.org"

new-website -Name "drm.pmi.org" -PhysicalPath c:\inetpub\wwwroot\drm.pmi.org -ApplicationPool "drm.pmi.org" -Id 2004

remove-webbinding -Name "drm.pmi.org" -Port 80

new-webbinding -Name "drm.pmi.org" -Port 80 -HostHeader "drm.candidate.pmi.org"

new-webbinding -Name "drm.pmi.org" -Port 443 -HostHeader "drm.candidate.pmi.org" -Protocol "https"


## Create ed.pmi.org site

remove-webapppool -name "ed.pmi.org"

new-webapppool -name "ed.pmi.org"

rmdir -recurse c:\inetpub\wwwroot\ed.pmi.org

mkdir c:\inetpub\wwwroot\ed.pmi.org

remove-website -Name "ed.pmi.org"

new-website -Name "ed.pmi.org" -PhysicalPath c:\inetpub\wwwroot\ed.pmi.org -ApplicationPool "ed.pmi.org" -Id 2005

remove-webbinding -Name "ed.pmi.org" -Port 80

new-webbinding -Name "ed.pmi.org" -Port 80 -HostHeader "ed.candidate.pmi.org"

new-webbinding -Name "ed.pmi.org" -Port 443 -HostHeader "ed.candidate.pmi.org" -Protocol "https"


## Create marketing.pmi.org site

remove-webapppool -name "marketing.pmi.org"

new-webapppool -name "marketing.pmi.org"

Set-ItemProperty iis:\apppools\marketing.pmi.org -name processModel -value @{userName="pmienvs\canwfeuser";password="P@55w*rd";identitytype=3}

Set-ItemProperty iis:\apppools\marketing.pmi.org -name managedRuntimeVersion -value "v4.0"

rmdir -recurse c:\inetpub\wwwroot\marketing.pmi.org

mkdir c:\inetpub\wwwroot\marketing.pmi.org

remove-website -Name "marketing.pmi.org"

new-website -Name "marketing.pmi.org" -PhysicalPath c:\inetpub\wwwroot\marketing.pmi.org -ApplicationPool "marketing.pmi.org" -Id 2018

remove-webbinding -Name "marketing.pmi.org" -Port 80

new-webbinding -Name "marketing.pmi.org" -Port 80 -HostHeader "marketing.candidate.pmi.org"

new-webbinding -Name "marketing.pmi.org" -Port 443 -HostHeader "marketing.candidate.pmi.org" -Protocol "https"


## Create marketplace.pmi.org site

remove-webapppool -name "marketplace.pmi.org"

new-webapppool -name "marketplace.pmi.org"

Set-ItemProperty iis:\apppools\marketplace.pmi.org -name processModel -value @{userName="pmienvs\canwfeuser";password="P@55w*rd";identitytype=3}

Set-ItemProperty iis:\apppools\marketplace.pmi.org -name managedPipelineMode -value 1

rmdir -recurse c:\inetpub\wwwroot\marketplace.pmi.org

mkdir c:\inetpub\wwwroot\marketplace.pmi.org

remove-website -Name "marketplace.pmi.org"

new-website -Name "marketplace.pmi.org" -PhysicalPath c:\inetpub\wwwroot\marketplace.pmi.org -ApplicationPool "marketplace.pmi.org" -Id 2006

remove-webbinding -Name "marketplace.pmi.org" -Port 80

new-webbinding -Name "marketplace.pmi.org" -Port 80 -HostHeader "marketplace.candidate.pmi.org"

new-webbinding -Name "marketplace.pmi.org" -Port 443 -HostHeader "marketplace.candidate.pmi.org" -Protocol "https"


## Create my.pmi.org site

remove-webapppool -name "my.pmi.org"

new-webapppool -name "my.pmi.org"

Set-ItemProperty iis:\apppools\my.pmi.org -name processModel -value @{userName="pmienvs\canorgservices";password="P@55w*rd";identitytype=3}

Set-ItemProperty iis:\apppools\my.pmi.org -name managedPipelineMode -value 1

rmdir -recurse c:\inetpub\wwwroot\my.pmi.org

mkdir c:\inetpub\wwwroot\my.pmi.org

remove-website -Name "my.pmi.org"

new-website -Name "my.pmi.org" -PhysicalPath c:\inetpub\wwwroot\my.pmi.org -ApplicationPool "my.pmi.org" -Id 2007

remove-webbinding -Name "my.pmi.org" -Port 80

new-webbinding -Name "my.pmi.org" -Port 80 -HostHeader "my.candidate.pmi.org"

new-webbinding -Name "my.pmi.org" -Port 443 -HostHeader "my.candidate.pmi.org" -Protocol "https"


## Create pathpro.pmi.org site

remove-webapppool -name "pathpro.pmi.org"

new-webapppool -name "pathpro.pmi.org"

Set-ItemProperty iis:\apppools\pathpro.pmi.org -name managedPipelineMode -value 1

rmdir -recurse c:\inetpub\wwwroot\pathpro.pmi.org

mkdir c:\inetpub\wwwroot\pathpro.pmi.org

remove-website -Name "pathpro.pmi.org"

new-website -Name "pathpro.pmi.org" -PhysicalPath c:\inetpub\wwwroot\pathpro.pmi.org -ApplicationPool "pathpro.pmi.org" -Id 2009

remove-webbinding -Name "pathpro.pmi.org" -Port 80

new-webbinding -Name "pathpro.pmi.org" -Port 80 -HostHeader "pathpro.candidate.pmi.org"

new-webbinding -Name "pathpro.pmi.org" -Port 443 -HostHeader "pathpro.candidate.pmi.org" -Protocol "https"


## Create search.pmi.org site

remove-webapppool -name "search.pmi.org"

new-webapppool -name "search.pmi.org"

Set-ItemProperty iis:\apppools\search.pmi.org -name processModel -value @{userName="pmienvs\canwfeuser";password="P@55w*rd";identitytype=3}

rmdir -recurse c:\inetpub\wwwroot\search.pmi.org

mkdir c:\inetpub\wwwroot\search.pmi.org

remove-website -Name "search.pmi.org"

new-website -Name "search.pmi.org" -PhysicalPath c:\inetpub\wwwroot\search.pmi.org -ApplicationPool "search.pmi.org" -Id 2010

remove-webbinding -Name "search.pmi.org" -Port 80

new-webbinding -Name "search.pmi.org" -Port 80 -HostHeader "search.candidate.pmi.org"

new-webbinding -Name "search.pmi.org" -Port 443 -HostHeader "search.candidate.pmi.org" -Protocol "https"


## Create standardsbenchmark.pmi.org site

remove-webapppool -name "standardsbenchmark.pmi.org"

new-webapppool -name "standardsbenchmark.pmi.org"

Set-ItemProperty iis:\apppools\standardsbenchmark.pmi.org -name managedRuntimeVersion -value "v4.0"

rmdir -recurse c:\inetpub\wwwroot\standardsbenchmark.pmi.org

mkdir c:\inetpub\wwwroot\standardsbenchmark.pmi.org

remove-website -Name "standardsbenchmark.pmi.org"

new-website -Name "standardsbenchmark.pmi.org" -PhysicalPath c:\inetpub\wwwroot\standardsbenchmark.pmi.org -ApplicationPool "standardsbenchmark.pmi.org" -Id 2016

remove-webbinding -Name "standardsbenchmark.pmi.org" -Port 80

new-webbinding -Name "standardsbenchmark.pmi.org" -Port 80 -HostHeader "standardsbenchmark.candidate.pmi.org"

new-webbinding -Name "standardsbenchmark.pmi.org" -Port 443 -HostHeader "standardsbenchmark.candidate.pmi.org" -Protocol "https"


## Create standardsnavigator.pmi.org site

remove-webapppool -name "standardsnavigator.pmi.org"

new-webapppool -name "standardsnavigator.pmi.org"

Set-ItemProperty iis:\apppools\standardsnavigator.pmi.org -name processModel -value @{userName="pmienvs\canwfeuser";password="P@55w*rd";identitytype=3}

Set-ItemProperty iis:\apppools\standardsnavigator.pmi.org -name managedRuntimeVersion -value "v4.0"

rmdir -recurse c:\inetpub\wwwroot\standardsnavigator.pmi.org

mkdir c:\inetpub\wwwroot\standardsnavigator.pmi.org

remove-website -Name "standardsnavigator.pmi.org"

new-website -Name "standardsnavigator.pmi.org" -PhysicalPath c:\inetpub\wwwroot\standardsnavigator.pmi.org -ApplicationPool "standardsnavigator.pmi.org" -Id 2017

remove-webbinding -Name "standardsnavigator.pmi.org" -Port 80

new-webbinding -Name "standardsnavigator.pmi.org" -Port 80 -HostHeader "standardsnavigator.candidate.pmi.org"

new-webbinding -Name "standardsnavigator.pmi.org" -Port 443 -HostHeader "standardsnavigator.candidate.pmi.org" -Protocol "https"


## Create static.pmi.org site

remove-webapppool -name "static.pmi.org"

new-webapppool -name "static.pmi.org"

rmdir -recurse c:\inetpub\wwwroot\static.pmi.org

mkdir c:\inetpub\wwwroot\static.pmi.org

remove-website -Name "static.pmi.org"

new-website -Name "static.pmi.org" -PhysicalPath c:\inetpub\wwwroot\static.pmi.org -ApplicationPool "static.pmi.org" -Id 2011

remove-webbinding -Name "static.pmi.org" -Port 80

new-webbinding -Name "static.pmi.org" -Port 80 -HostHeader "static.candidate.pmi.org"

new-webbinding -Name "static.pmi.org" -Port 443 -HostHeader "static.candidate.pmi.org" -Protocol "https"



## Create vc.pmi.org site

remove-webapppool -name "vc.pmi.org"

new-webapppool -name "vc.pmi.org"

Set-ItemProperty iis:\apppools\vc.pmi.org -name processModel -value @{userName="pmienvs\canwfeuser";password="P@55w*rd";identitytype=3}

rmdir -recurse c:\inetpub\wwwroot\vc.pmi.org

mkdir c:\inetpub\wwwroot\vc.pmi.org

remove-website -Name "vc.pmi.org"

new-website -Name "vc.pmi.org" -PhysicalPath c:\inetpub\wwwroot\vc.pmi.org -ApplicationPool "vc.pmi.org" -Id 2012

remove-webbinding -Name "vc.pmi.org" -Port 80

new-webbinding -Name "vc.pmi.org" -Port 80 -HostHeader "vc.candidate.pmi.org"



## Create vrms.pmi.org site

remove-webapppool -name "vrms.pmi.org"

new-webapppool -name "vrms.pmi.org"

Set-ItemProperty iis:\apppools\vrms.pmi.org -name managedRuntimeVersion -value "v4.0"

rmdir -recurse c:\inetpub\wwwroot\vrms.pmi.org

mkdir c:\inetpub\wwwroot\vrms.pmi.org

remove-website -Name "vrms.pmi.org"

new-website -Name "vrms.pmi.org" -PhysicalPath c:\inetpub\wwwroot\vrms.pmi.org -ApplicationPool "vrms.pmi.org" -Id 2020

remove-webbinding -Name "vrms.pmi.org" -Port 80

new-webbinding -Name "vrms.pmi.org" -Port 80 -HostHeader "vrms.candidate.pmi.org"

new-webbinding -Name "vrms.pmi.org" -Port 443 -HostHeader "vrms.candidate.pmi.org" -Protocol "https"



## Create www.pmi.org site

remove-webapppool -name "www.pmi.org"

new-webapppool -name "www.pmi.org"

Set-ItemProperty iis:\apppools\www.pmi.org -name processModel -value @{userName="pmienvs\canorgservices";password="P@55w*rd";identitytype=3}

Set-ItemProperty iis:\apppools\www.pmi.org -name managedPipelineMode -value 1

rmdir -recurse c:\inetpub\wwwroot\www.pmi.org

mkdir c:\inetpub\wwwroot\www.pmi.org

remove-website -Name "www.pmi.org"

new-website -Name "www.pmi.org" -PhysicalPath c:\inetpub\wwwroot\www.pmi.org -ApplicationPool "www.pmi.org" -Id 2013

remove-webbinding -Name "www.pmi.org" -Port 80

new-webbinding -Name "www.pmi.org" -Port 80 -HostHeader "www.candidate.pmi.org"

new-webbinding -Name "www.pmi.org" -Port 443 -HostHeader "www.candidate.pmi.org" -Protocol "https"


## Create admin.pmi.org site

remove-webapppool -name "admin.pmi.org"

new-webapppool -name "admin.pmi.org"

Set-ItemProperty iis:\apppools\admin.pmi.org -name processModel -value @{userName="pmienvs\canwfeuser";password="P@55w*rd";identitytype=3}

rmdir -recurse c:\inetpub\wwwroot\admin.pmi.org

mkdir c:\inetpub\wwwroot\admin.pmi.org

remove-website -Name "admin.pmi.org"

new-website -Name "admin.pmi.org" -PhysicalPath c:\inetpub\wwwroot\admin.pmi.org -ApplicationPool "admin.pmi.org" -Id 1000

remove-webbinding -Name "admin.pmi.org" -Port 80

new-webbinding -Name "admin.pmi.org" -Port 80 -HostHeader "admin.candidate.pmi.org"

new-webbinding -Name "admin.pmi.org" -Port 443 -HostHeader "admin.candidate.pmi.org" -Protocol "https"


## Create admin.pmi.org-admin site

mkdir c:\inetpub\wwwroot\admin.pmi.org\admin

new-webvirtualdirectory -Site "admin.pmi.org" -Name admin -PhysicalPath c:\inetpub\wwwroot\admin.pmi.org\admin

convertto-WebApplication -ApplicationPool "admin.pmi.org" "iis:\sites\admin.pmi.org\admin"


## Create admin.pmi.org-adminextensions site

mkdir c:\inetpub\wwwroot\admin.pmi.org\adminextensions

new-webvirtualdirectory -Site "admin.pmi.org" -Name adminextensions -PhysicalPath c:\inetpub\wwwroot\admin.pmi.org\adminextensions

convertto-WebApplication -ApplicationPool "admin.pmi.org" "iis:\sites\admin.pmi.org\adminextensions"
