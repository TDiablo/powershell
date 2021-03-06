$schedulejobserver="307356-SEARCH01.global.pmihq.org"
$source="\\deploy.pmienvs.pmihq.org\Releases\Teams\Apps\BRE02252012\CommunitiesMembershipSync"
$destination="\\$schedulejobserver\c$\PMI\BRE02252012\"

#Copy the XML file to the Schedule Jobs Server
copy-item $source $destination -recurse

#Create the task and import the XML file to configure it
schtasks /S $schedulejobserver /create /TN "PMI\Communities Membership Sync\RuleCommunitiesMembershipSync" /XML \\$schedulejobserver\c$\PMI\BRE02252012\RuleCommunitiesMembershipSync.xml

#Enable the task
schtasks /S $schedulejobserver /change /TN "PMI\Communities Membership Sync\RuleCommunitiesMembershipSync" /ENABLE
