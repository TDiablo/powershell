$machinelist =@("QA2-WEB1.homenet.local")

$machinelist | foreach {
    $webmachine = $_ 
    $Username = 'HOMENET\autobuilder'
    $Password = 'stupidpassword'
    $pass = ConvertTo-SecureString -AsPlainText $Password -Force
    $Cred = New-Object System.Management.Automation.PSCredential -ArgumentList $Username,$pass

    
    $u = 'IOL2Web'
    $AppPassword = 't+2xb?fk'
    $AppDomain = 'homenet'
    #$u = 'IOLutils'
    #$AppPassword = 'Ipsbm0xxCqLAsc7F'
    $ProfilePath = "C:\Users\$u\Documents\Profile.txt"
    $AppUsername = "$AppDomain\$u"   

    #First Get User SID
    $objUser = New-Object System.Security.Principal.NTAccount($AppDomain, $u)
    $strSID = $objUser.Translate([System.Security.Principal.SecurityIdentifier])
    $strSID.Value

    $Apppass = ConvertTo-SecureString -AsPlainText $AppPassword -Force
    $AppCred = New-Object System.Management.Automation.PSCredential -ArgumentList $AppUsername,$Apppass

    echo $ProfilePath
        
    echo "******************************************************"
    echo $webmachine " - Repairing IOL2Web Profile"
    echo "******************************************************"
    
    $s = New-PSSession -ComputerName $webmachine -Credential $Cred
    $Appsession = New-PSSession -ComputerName $webmachine -Credential $AppCred
    
    $Res = (Invoke-command -Session $s -ScriptBlock {Get-Service w3svc})
    echo "Stopping " $Res.Displayname
    Invoke-command -Session $s -ScriptBlock {Stop-Service w3svc}
    
    echo "adding to local admin"
    Invoke-command -Session $s -ScriptBlock {cmd /c "net localgroup administrators HOMENET\IOL2Web /add"} 
    echo "creating text file."
    #kill all tasks running under Username
    Invoke-command -Session $s -ScriptBlock {TASKKILL.EXE /FI "USERNAME eq $u" /IM *}
    #Disassociate Temp Folders from User
    # delete profile mapping registry key
    Invoke-command -Session $s -ScriptBlock {Start-Service w3svc
    #Delete User from ProfileList
    Invoke-command -Session $s -ScriptBlock {Start-Service w3svc
    
    
    echo $ProfilePath
    Invoke-command -Session $Appsession -ScriptBlock {cmd /c echo "A text file has been created." >  Profile2.txt}
    echo "Starting " $Res.Displayname
    Invoke-command -Session $s -ScriptBlock {Start-Service w3svc} 
    echo "deleting from to local admin"
    Invoke-command -Session $s -ScriptBlock {cmd /c "net localgroup administrators HOMENET\IOL2Web /del"}
    $cmd = "Get-Content -Path $ProfilePath"
    $Stat=(Invoke-command -Session $s -ScriptBlock {$cmd})
    $cmd = "cmd /c del $ProfilePath"
    #Invoke-command -Session $s -ScriptBlock {$cmd}

    
    echo $Stat



    Remove-PSSession $s
    Remove-PSSession $Appsession
    echo "WORK COMPLETE - ZUG ZUG"
}


