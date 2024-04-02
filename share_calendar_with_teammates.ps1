# Get the manager (and their ID)
$manager = Get-MgUser -Filter "DisplayName eq '$(Read-Host 'Enter the managers displayname')'"

# Get all the IDs of the manager's direct reports
$managed_users = Get-MgUserDirectReport -UserId $manager.id

# Get the actual MG-User for each of those IDs
$users = foreach ($user in $managed_users) {Get-MgUser -userid $user.id}

# Give the permissions
foreach ($user in $users)
{
	Write-Host "$($user.displayname) <- $($manager.displayname)"
	
	# Give their manager write permissions
	Add-MailboxFolderPermission -Identity "$($user.mail):\Calendar" -User "$($manager.mail)" -AccessRights Editor -SharingPermissionFlags Delegate

	Write-Host "$($user.displayname) -> $($manager.displayname)"

	# And vice-versa
	Add-MailboxFolderPermission -Identity "$($manager.mail):\Calendar" -User "$($user.mail)" -AccessRights Reviewer

	# Give read access to the teammates
	foreach ($user2 in $users)
	{
		# Don't give read access to themselves, that could probably break things
		if ($user.mail -ne $user2.mail)
		{
			Write-Host "$($user.displayname) <- $($user2.displayname)"
			Add-MailboxFolderPermission -Identity "$($user.mail):\Calendar" -User "$($user2.mail)" -AccessRights Reviewer
		}
	}
}
