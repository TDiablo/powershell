$datetime="2012025-0800"
#$wfearray="etoro64-pc.pmint.pmihq.org","localhost","127.0.0.1"
$wfearray="243886-WFE01.global.pmihq.org", "243892-WFE02.global.pmihq.org", "243893-WFE03.global.pmihq.org"
$dotNet64v4="c$\Windows\Microsoft.NET\Framework64\v4.0.30319\CONFIG"
$environment="production"

foreach ($wfe in $wfearray){
    #Backup config file
    copy-item "\\$wfe\$dotNet64v4\web.config" "\\$wfe\$dotNet64v4\web.config.$datetime.txt"

    #Load the config file
    $xmlfile = New-Object XML
    $xmlfile.Load("\\$wfe\$dotNet64v4\web.config")

    #Get the existing connection string to clone in next step
    $existingstring = @($xmlfile.configuration.connectionStrings.add)[0]

    #Clone the connection string to a new object so it can be modified in separate memory space
    $newconnstring = $existingstring.Clone()

    #Modify the new conection string object
    $newconnstring.connectionString = "Server=vrmsdb.$environment.pmi.org;Database=VRMS;User ID=pmi_web_user;Password=gophillies"
    $newconnstring.name = "Web_PMI_VRMS"

    #Insert the new connection string object into the xml object
    $xmlfile.configuration.connectionStrings.AppendChild($newconnstring)

    #DEBUG: Prints the connectionStrings object before commiting change
    #$xmlfile.configuration.connectionStrings.add

    #Commit your changes to the file system
    $xmlfile.Save("\\$wfe\$dotNet64v4\web.config")

    #DEBUG: Print the xml file for verification
    #Get-Content "\\$wfe\$dotNet64v4\web.config"
    }