$lowerfileserver="files2.staging.pmi.org"
$higherfileserver="395036-filesrv.global.pmihq.org"

$source="\\$lowerfileserver\mypmi"
$destination="\\$higherfileserver\d$\myPMI"
copy-item $source $destination -recurse

$username = "global\wfeuser1"
$permissions = Get-Acl $destination
$userpermissions = New-Object System.Security.AccessControl.FileSystemAccessRule($username,“FullControl”, “ContainerInherit, ObjectInherit”, “None”, “Allow”)
$permissions.AddAccessRule($userpermissions)
Set-Acl $destination $permissions
