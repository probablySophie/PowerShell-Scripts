$groupusers = Get-MgGroupMember -GroupId (Read-Host "Group ID") -all; $users = $groupusers | ForEach {Get-MgUser -UserId $_.id}; $users | Format-Table -Property DisplayName, OfficeLocation, JobTitle; Write-Host "$($users.length) users in group`n"
