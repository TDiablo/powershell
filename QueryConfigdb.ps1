<#
.SYNOPSIS
    This script requires you to run with ADM / Domain Admin account.
    Calls PMI databases to retrieve info and output to file
.DESCRIPTION
    See synopsis
.INPUTS
    Environment Name
.OUTPUTS
    Txt file
.PARAMETER environment
    Environment Name
.LINK
    None
.EXAMPLE
    querycoreenv.ps1 -environment candidate
.NOTES
    Author: Emmanuel Toro
    Date:   May 17, 2013
#>

Param(
	[validateset("integration","qa","staging","candidate","production","erpint","erpqa","uat","ord","pos")]
    [parameter(Mandatory=$true, Position=1)]
    $environment
)

#PURPOSE: Add a leading zero to a single digit. Don't be a jerk and pass a negative number.
#ARGUMENTS: Integer
#RETURN: A two digit number as a string
function AddZero ([int]$number) {
    if (!$number){
        return "00"
    }
    
    if ($number -lt 10){
        return "0" + $number
    }
    else{
        return "$number"
    }

}

#PURPOSE: Get the date and time 
#ARGUMENTS: NONE
#RETURN: string in format YYYYMMDD_HHMMSS
function GetDateTime{
    
    [string]$result=$null
    [string]$str_year=((Get-Date).Year).ToString()
    
    [int]$int_month=(Get-Date).Month
    [int]$int_day=(Get-Date).Day
    [int]$int_hour=(Get-Date).Hour
    [int]$int_minute=(Get-Date).Minute
    [int]$int_second=(Get-Date).Second
    
    [string]$str_month=AddZero $int_month
    [string]$str_day=AddZero $int_day
    [string]$str_hour=AddZero $int_hour
    [string]$str_minute=AddZero $int_minute
    [string]$str_second=AddZero $int_second
    
    
    $result = "$str_year$str_month$str_day" + "_" + "$str_hour$str_minute$str_second"
    return $result
}

#PURPOSE: Output the XML with pretty tabs
#ARGUMENTS: XML row, number of spaces
#RETURN: NONE
function XMLFormatting($xml,$indent){
    $StringWriter = New-Object System.IO.StringWriter 
    $XmlWriter = New-Object System.XMl.XmlTextWriter $StringWriter 
    $xmlWriter.Formatting = "indented" 
    $xmlWriter.Indentation = $indent 
    $xml.WriteContentTo($XmlWriter) 
    $XmlWriter.Flush() 
    $StringWriter.Flush() 
    Write-Output $StringWriter.ToString() >> ".\$outputfilename"
}


#PURPOSE: Calls database to retrieve data
#ARGUMENTS: Environment name
#RETURN: NONE
function GetPMIcoreEnvironmentData ( $environment, $outputfilename ) {

#NOTE: The section below does not like to be tabbed or it will mess up the color scheme in the PowerShell ISE.
$query = @"
select "name", "xmlvalue"
from dbo.Configurations
order by "name"
"@
    $connection = $null

	if ( $environment -eq "production"){
		$connection = new-object system.data.sqlclient.sqlconnection( "Server=pmi_coreenvironmentdb.production.pmi.org;Database=PMI_CoreEnvironment;Integrated Security=SSPI;User ID=pmi_web_user;Password=gophillies;" )
	}
	else {
		$connection = new-object system.data.sqlclient.sqlconnection( "Server=pmi_coreenvironmentdb.$environment.pmi.org;Database=PMI_CoreEnvironment;User ID=pmi_web_user;Password=Password1;" )
	}

    if ( $connection -ne $null ){
        Write-Host "Connecting to database..."
        $adapter = new-object system.data.sqlclient.sqldataadapter ($query, $connection)
        $table = new-object system.data.datatable
        $totalrows = $adapter.Fill($table)
        
        $message = "Total rows to output: $totalrows"
        Write-Host $message
        Write-Output $message >> ".\$outputfilename"
        
        $message = "PMI_CoreEnvironment database - dbo.Configurations - name and xmlvalue column"
        Write-Host $message
        Write-Output $message >> ".\$outputfilename"
        
        foreach ( $row in $table.rows ){
            Write-Host "Outputting" $row.name
            Write-Output $row.name >> ".\$outputfilename"
            [string]$xmlout = $row.xmlvalue.ToString()
            $xmlcat = [xml]$xmlout
            XMLFormatting $xmlcat 5
            Write-Output "" >> ".\$outputfilename"
            Write-Output "" >> ".\$outputfilename"
        }
    } else {
        Write-Host "The environment specified does not exist"
    }

}


function GetPMIEmailFromAddress ( $environment, $outputfilename ){

#NOTE: The section below does not like to be tabbed or it will mess up the color scheme in the PowerShell ISE.
$query = @"
select "FromEmailAddress"
from dbo.EmailQueueOriginatingApplication
"@
    $connection = $null

	if ( $environment -eq "production"){
		$connection = new-object system.data.sqlclient.sqlconnection( "Server=pmi_emaildb.production.pmi.org;Database=PMI_Email;Integrated Security=SSPI;User ID=pmi_web_user;Password=gophillies;" )
	}
	else {
		$connection = new-object system.data.sqlclient.sqlconnection( "Server=pmi_emaildb.$environment.pmi.org;Database=PMI_Email;User ID=pmi_web_user;Password=Password1;" )
	}
	
    if ( $connection -ne $null ){
        Write-Host "Connecting to database..."
        $adapter = new-object system.data.sqlclient.sqldataadapter ($query, $connection)
        $table = new-object system.data.datatable
        $totalrows = $adapter.Fill($table)
        
        $message = "Total rows to output: $totalrows"
        Write-Host $message
        Write-Output $message >> ".\$outputfilename"
        
        $message = "PMI_Email database - dbo.EmailQueueOriginatingApplication - FromEmailAddress column"
        Write-Host $message
        Write-Output $message >> ".\$outputfilename"
        
        foreach ( $row in $table.rows ){
            Write-Host "Outputting" $row.FromEmailAddress
            Write-Output $row.FromEmailAddress >> ".\$outputfilename"
        }
        Write-Output "" >> ".\$outputfilename"
        Write-Output "" >> ".\$outputfilename"
    } else {
        Write-Host "The environment specified does not exist"
    }

}


function GetPathProSitedomain ( $environment, $outputfilename ){

#NOTE: The section below does not like to be tabbed or it will mess up the color scheme in the PowerShell ISE.
$query = @"
select "domain"
from dbo.SiteDomain
"@
    $connection = $null

	if ( $environment -eq "production" -or $environment -eq "integration" ){
		$connection = new-object system.data.sqlclient.sqlconnection( "Server=pathprodb.production.pmi.org;Database=PathPro;User ID=svcsPathPro;Password=lACpAs56IKMs" )
	}
	elseif ( $environment -eq "qa" -or $environment -eq "staging" ){
		$connection = new-object system.data.sqlclient.sqlconnection( "Server=pathprodb.$environment.pmi.org;Database=Pathpro;User ID=svcsPathPro;Password=p2RuTrUv" )
	}
	else {
		$connection = new-object system.data.sqlclient.sqlconnection( "Server=pathprodb.$environment.pmi.org;Database=Pathpro;User ID=svcsPathPro;Password=Password1" )
	}

    if ( $connection -ne $null ){
        Write-Host "Connecting to database..."
        $adapter = new-object system.data.sqlclient.sqldataadapter ($query, $connection)
        $table = new-object system.data.datatable
        $totalrows = $adapter.Fill($table)
        
        $message = "Total rows to output: $totalrows"
        Write-Host $message
        Write-Output $message >> ".\$outputfilename"
        
        $message = "PathPro database - dbo.SiteDomain - domain column"
        Write-Host $message
        Write-Output $message >> ".\$outputfilename"
        
        foreach ( $row in $table.rows ){
            Write-Host "Outputting" $row.domain
            Write-Output $row.domain >> ".\$outputfilename"
        }
        Write-Output "" >> ".\$outputfilename"
        Write-Output "" >> ".\$outputfilename"
    } else {
        Write-Host "The environment specified does not exist"
    }

}

function GetPMIcoreData ( $environment, $outputfilename ){

#NOTE: The section below does not like to be tabbed or it will mess up the color scheme in the PowerShell ISE.
$query = @"
select "BaseURL"
from dbo.ESP2_ServiceMethod
"@
    $connection = $null

	if ( $environment -eq "production"){
		$connection = new-object system.data.sqlclient.sqlconnection( "Server=pmi_coreenvironmentdb.production.pmi.org;Database=PMI_Core;Integrated Security=SSPI;User ID=pmi_web_user;Password=gophillies;" )
	}
	else {
		$connection = new-object system.data.sqlclient.sqlconnection( "Server=pmi_coreenvironmentdb.$environment.pmi.org;Database=PMI_Core;User ID=pmi_web_user;Password=Password1;" )
	}
	
    if ( $connection -ne $null ){
        Write-Host "Connecting to database..."
        $adapter = new-object system.data.sqlclient.sqldataadapter ($query, $connection)
        $table = new-object system.data.datatable
        $totalrows = $adapter.Fill($table)
        
        $message = "Total rows to output: $totalrows"
        Write-Host $message
        Write-Output $message >> ".\$outputfilename"
        
        $message = "PMI_Core database - dbo.ESP2_ServiceMethod"
        Write-Host $message
        Write-Output $message >> ".\$outputfilename"
        
        foreach ( $row in $table.rows ){
            Write-Host "Outputting" $row.BaseURL
            Write-Output $row.BaseURL >> ".\$outputfilename"
        }
        Write-Output "" >> ".\$outputfilename"
        Write-Output "" >> ".\$outputfilename"
    } else {
        Write-Host "The environment specified does not exist"
    }

}


#MAIN
$date = GetDateTime
$outputfilename = "PMI_EnvironmentDatabases_" + "$date" + "_$environment.txt"
    
GetPMIcoreEnvironmentData $environment $outputfilename

GetPMIEmailFromAddress $environment $outputfilename

GetPathProSitedomain $environment $outputfilename

GetPMIcoreData $environment $outputfilename