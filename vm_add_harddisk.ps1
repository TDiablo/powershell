#Get datastore with most available storage
$DataStore = Get-Datastore -datacenter ENVS | select Name,FreeSpaceMB | Sort-Object FreeSpaceMB -desc | select -first 1
$MaxDataStore=$DataStore.name

#accept arguments
#Validate space

#Set VM to use
$VMName=$args[0]
#set storage size
$DiskSize=($args[1]*1048576)

write-host  $VMName $DiskSize $MaxDataStore

New-HardDisk -CapacityKB $DiskSize -DataStore $MaxDataStore -VM $VMName

#-confirm:$false