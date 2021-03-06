$environment="production"
$fileserver="files2.$environment.pmi.org"
$targetshare="myPMI"
$foldername="C:\inetpub\wwwroot\my.pmi.org\Content"
$symlinkdir="pdf"


#Establish sessions
$sessions = New-PSSession -ComputerName 243886-WFE01.global.pmihq.org, 243892-WFE02.global.pmihq.org, 243893-WFE03.global.pmihq.org

#Invoke the block below remotely. Sessions ran in separate threads simultaneously
invoke-command -session $sessions -Script {

    #Assigned passed in parameters to variables
    param($arg_foldername, $arg_symlinkdir, $arg_filesrv,$arg_targetshare)

    #Debug
    WRITE-HOST $arg_foldername
    WRITE-HOST $arg_symlinkdir
    WRITE-HOST $arg_filesrv
    WRITE-HOST $arg_targetshare
    
    #If folder does not exist, create it
    IF ( !(TEST-PATH $arg_foldername ) ) {
        New-Item $arg_foldername -type directory
    }
    
    $symlinkpath="$arg_foldername\$arg_symlinkdir"

    #If the symlink path exists, you cannot create a symlink
    IF ( !(TEST-PATH $symlinkpath ) ) {
        cmd /c mklink /d $symlinkpath \\$arg_filesrv\$arg_targetshare
    } 
    ELSE {
        WRITE-HOST "ERROR: Symlink not created. $arg_folder already exists. Check folder."
    }
    
    #Arguments passed into invoke-command block    
} -Args $foldername,$symlinkdir,$fileserver,$targetshare
    
#End sessions
remove-pssession -session $sessions