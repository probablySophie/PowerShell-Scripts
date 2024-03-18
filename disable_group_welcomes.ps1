clear

Write-Host "Getting groups, this could take a little while..."
$M365Groups = Get-UnifiedGroup -ResultSize Unlimited  # Get every group available

$count = 1;
$len = $M365Groups.length;

foreach ($group in $M365Groups)
{
	Write-Host -nonewline "$($count)/$($len) `t" # for prettiness

	# if the current group has welcome messages enabled
	if ($group.WelcomeMessageEnabled -eq $true)
	{
		# disable the welcome messages & send any output from that command into the bin
		Set-UnifiedGroup $group.Identity -UnifiedGroupWelcomeMessageEnabled:$false *>$null
		Write-Host -nonewline "updated     `t";
	}
	else
	{
		Write-Host -nonewline "already set `t";
	}
	Write-Host "$($group.DisplayName)";
	$count++;
}
