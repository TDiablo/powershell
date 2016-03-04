
$url = 'https://secretserver.pmi.org/webservices/sswebservice.asmx'
$login = 'pmienvs\'
$password ='5up#r53CurE!'
$domain = ''   # leave blank for local users
$FieldName = 'username'
$username = 'uatsqlsvc'
$proxy = New-WebServiceProxy -uri $url -UseDefaultCredential
$result1 = $proxy.Authenticate($login, $password, '', $domain)

if ($result1.Errors.length -gt 0){
	$result1.Errors[0]
    exit
} 
else 
{
	$token = $result1.Token
#$token

}
$Secret = $proxy.GetSecretsbyFieldValue($token, $FieldName, $username,0)
if ($Secret.Errors.length -gt 0){
	$Secret.Errors[0]
}
else
{
	$SecretID = $Secret.Secrets.ID
    $SecretLegacy= $proxy.GetSecretLegacy($token, $SecretID)
#    $Secretlegacy.Secret
#    $Secretlegacy.Secret.Items[2].FieldName
	$Secretlegacy.Secret.Items[2].Value




	

# If you want the data as XML
#	$xml = convertto-xml $result.Secret -As string -Depth 20
#	$xml

# if you want to update the password field
#	$newpassword = 'foobee123456'
#	$result2.Secret.Items[2].Value = $newpassword
#	$result3 = $proxy.UpdateSecret($token, $result2.Secret)
#	if ($result3.Errors.length -gt 0){
#		$result1.Errors[0]
#		exit
#	} 

}