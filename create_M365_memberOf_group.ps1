clear

$groupName = Read-Host "Group Name: "
$email = Read-Host "Email Nickname: " # We are just going to unsafely assume that the email nickname is free

$groupName_manual = $groupName+"_Manual"
$groupName_dynamic = $groupName+"_Dynamic"

### Check if the groups already exist
function does_group_exist($groupName)
{
	Write-Host "Checking if a group with the name: '$($groupName)' already exists"
	$group = Get-MgGroup -Filter "DisplayName eq '$($groupName)'";

	# If the group is NULL then we're good
	if ($group -eq $NULL)
	{
		Write-Host "Group does not exist"
		return $False
	}

	# If the group is a distribution group then we're good
	# The table for which is which is here: https://learn.microsoft.com/en-us/graph/api/resources/groups-overview?view=graph-rest-1.0&tabs=http
	if ( ($group.GroupTypes.length -eq 0) -and ($group.mailEnabled -eq $True) -and ($group.securityEnabled -eq $False) )
	{
		Write-Host "Group exists but is a distribution group"
		return $False
	}

	# Otherwise we're in trouble
	Write-Warning ("A group with the name $($groupName) already exists!")
	return $True
}

# Check if any of the group names we want to use are already taken
$groupExists = $False
$groupExists = $groupExists -or (does_group_exist($groupName))
$groupExists = $groupExists -or (does_group_exist($groupName_manual))
$groupExists = $groupExists -or (does_group_exist($groupName_dynamic))

### Exit this script if the groups already exist
if ($groupExists -eq $True)
{
	Write-Warning "Exiting..."
	Exit
}

Write-Host "Creating Manual Group..."
$group_manual = New-MgGroup `
	-DisplayName $groupName_manual `
	-SecurityEnabled `
	-mailEnabled:$False `
	-MailNickName ($email+"_manual") `
	-description "The Manually assigned feeder group for the $($groupName) M365 Group"

Write-Host "Creating Dynamic Group..."
$group_dynamic = New-MgGroup `
	-DisplayName $groupName_dynamic `
 	-SecurityEnabled `
 	-mailEnabled:$False `
 	-MailNickName ($email+"_dynamic") `
 	-description "The Dynamically assigned feeder group for the $($groupName) M365 Group"

### Double check that both groups' IDs aren't NULL
if ( -not ( ($group_manual -eq $NULL) -and ($group_dynamic -eq $NULL) ) )
{
	Write-Host "Creating M365 Group..."
	# Make the M365 Group
	New-MgGroup `
 		-DisplayName $groupName `
 		-MailEnabled `
 		-MailNickName $email `
 		-GroupTypes ("Unified", "DynamicMembership") `
 		-MembershipRule "user.memberof -any (group.objectId -in ['$($group_manual.id)', '$($group_dynamic.id)'])" `
 		-securityEnabled `
 		-membershipRuleProcessingState "on" `
 		-description "Pulls users from the groups $($groupName_manual) & $($groupName_dynamic)"

	Write-Host "Finished :)"
}
else
{
	Write-Warning "Manual and/or Dynamic groups not created successfully"
}
