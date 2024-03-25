# Connect to the Microsoft Graph server using the permissions we need
Connect-MgGraph -Scopes 'DeviceManagementManagedDevices.Read.All, User.Read.All'


Write-Host "Getting Devices..."

$devices = Get-MgBetaDeviceManagementManagedDevice -all

$formatted_devices = @()

Write-Host "Running..."
$count = 1;
$total = $devices.length

foreach ($device in $devices)
{
	Write-Host "Device $($count) of $($total)"

	$userid = $device.UsersLoggedOn[0].userid
	$username = "No User Found"
	$devicename = $device.DeviceName

	if ($userid -ne $Null)
	{
		Write-Host "Getting User..."
		$user = Get-MgBetaUser -UserId $userid
		$username = $user.DisplayName
	}

	$formatted_devices += New-Object PSCustomObject -Property (@{
		"userid"=$userid
		"devicename"=$devicename
		"username"=$username
	})

	$count++;
}

$formatted_devices | Format-Table
