##########################################################
# Test-Site - script to test web site availability
# and notify in case of any issues
# Hans Bader
# Based on Script found on the internet
# updated to load URLs from txt file, write status to txt file
##########################################################

$logfile ="webstatus.log"
$urlList="urllist.txt"

function Test-Site {
    param($URL)
    trap{
        "Failed. Details: $($_.Exception)"
        $emailFrom = "QA01Monitor@pmi.org"
        # Use commas for multiple addresses
      #  $emailTo = "hans.bader@pmi.org"
        $emailTo = "Tom.DiObilda@pmi.org,Jason.Edonick@pmi.org, jim.joseph@pmi.org "
 
        $subject = "Web Site is DOWN"
        $body = "$URL is DOWN: $($_.Exception)"
		$downLog="DOWN , " + $URL
		WRITE_LOG $downLog
        $smtpServer = "172.19.0.151"
        $smtp = new-object Net.Mail.SmtpClient($smtpServer)
        $smtp.Send($emailFrom, $emailTo, $subject, $body)
				
        exit 1
    }
    $webclient = New-Object Net.WebClient
    # The next 5 lines are required if your network has a proxy server
    $webclient.Credentials = [System.Net.CredentialCache]::DefaultCredentials
    if($webclient.Proxy -ne $null)     {
        $webclient.Proxy.Credentials = `
                [System.Net.CredentialCache]::DefaultNetworkCredentials
    }
    # This is the main call
	    
		$downLog="UP , " + $URL
		WRITE_LOG $downLog
    $webclient.DownloadString($URL) | Out-Null
} 



Function WRITE_LOG
{
	Param([string]$MESSAGE)

	$logdate = get-date
	$logyr = $logdate.Year.ToString()
	$logmo = $logdate.Month.ToString()
	$logdy = $logdate.Day.ToString()
	$loghr = $logdate.Hour.ToString()
	$logmi = $logdate.Minute.ToString()
	$logsc = $logdate.Second.ToString()

	$logstamp = $logyr + "-" + $logmo + "-" + $logdy + ", " + $loghr + ":" + $logmi + ":" + $logsc + "`t" + " ," + $MESSAGE

	write-output $logstamp | Out-File $logfile -append

}

#----------------------------------------------------------
#FUNCTION CREATE_LOG
#----------------------------------------------------------
Function CREATE_LOG
{
	#TEST IF THE OLD FILE EXISTS
	Test-Path $logfile
		if (! $?)
			#THE FILE DOES NOT EXIST, SO WE CREATE A NEW LOGFILE
			{new-item $logfile -type file}
			
				if (! $?)
					{write-ouput "FAILED TO CREATE LOGFILE"
					Exit}
}



CREATE_LOG

$sites = get-content $urlList

foreach($i in $sites)
{
Test-Site $i
}