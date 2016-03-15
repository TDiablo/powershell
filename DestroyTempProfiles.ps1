$Environment = $args[0]

$machinelist = cmd /c "c:\homenet\tools\buildtools\SettingsHelper.exe -e $Environment Machines.ListMachinesForApplication(InventoryOnline2-Website)"

echo $machinelist

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
    $UserSID=$strSID.Value

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
    Invoke-command -Session $s -ScriptBlock {
        $using:AppUsername
        echo $using:AppUsername
        If ($using:AppUsername -eq [String]::Empty){            
            Write-Host "Username is empty"
            Exit
        }     
        Else {
           Write-Host "Adding $using:Appusername to Local Admin" 
           cmd /c "net localgroup administrators $Using:AppUsername /add"} 
        }
    
    #kill all tasks running under Username
    Invoke-command -Session $s -ScriptBlock {
        $using:u
        if ($using:u -eq [String]::Empty){
            Write-Host "Username is empty"
            Exit
        }     
        Else {
            TASKKILL.EXE /FI "USERNAME eq $using:u" /IM *
        }

    }
    #Disassociate Temp Folders from User

    Invoke-command -Session $s -ScriptBlock {
        $Using:USerSID
        echo $Using:USerSID
        If ($Using:USerSID-eq [String]::Empty){
            Write-Host "Username is empty"
            Exit
        }     
        Else {
            Write-Host "Messing with the registry"
            #Delete profile mapping registry key
            #Remove-Item -Path "hku:\$USerSID\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" -Recurse
            #Delete User from ProfileList
            #Remove-Item -Path "hklm:\Software\Microsoft\Windows NT\CurrentVersion\ProfileList\$USerSID" -Recurse
        }
    
    }
    echo $ProfilePath
    #Invoke-command -Session $Appsession -ScriptBlock {cmd /c echo "A text file has been created." >  Profile2.txt}
    echo "Starting " $Res.Displayname
    Invoke-command -Session $s -ScriptBlock {Start-Service w3svc} 

    #Remove from Local admin
    Invoke-command -Session $s -ScriptBlock {
        $using:AppUsername
        echo $using:AppUsername
        If ($using:AppUsername -eq [String]::Empty){            
            Write-Host "Username is empty"
            Exit
        }     
        Else {
            Write-Host "Removing $using:AppUsername from local admin"
            cmd /c "net localgroup administrators $using:AppUsername /del"
    }
    
    #Clean up your mess
    Invoke-command -Session $s -ScriptBlock {
        $using:ProfilePath
        if (using:ProfilePath -eq [String]::Empty){            
            Write-Host "Profile path is empty"
            Exit
        }     
        Else {
            cmd /c "del $ProfilePath"
        }
    }




    Remove-PSSession $s
    Remove-PSSession $Appsession
    echo "WORK COMPLETE - ZUG ZUG"

