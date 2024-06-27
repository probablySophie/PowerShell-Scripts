Connect-MgGraph -Scopes 'DeviceManagementManagedDevices.Read.All', 'User.Read.All'

$managed_devices = Get-MgBetaDeviceManagementManagedDevice -all

Write-Host "Got $($managed_devices.length) devices!"


$formatted_devices = @()

Write-Host "Running..."
$count = 1;
$total = $devices.length

foreach ($device in $managed_devices)
{
	if ($device.UsersLoggedOn.length -gt 0)
	{
		$user = get-MgBetaUser -userID $device.UsersLoggedOn[0].UserId
	}
	else
	{
		$user = [PSCustomObject]@{
			DisplayName = ""
			OfficeLocation = ""
		}
	}

	if ($device.OperatingSystem -eq "Windows")
	{
		$category = "Laptop"
	}
	elseif ($device.OperatingSystem -eq "iOS") {
		$category = "Phone"
	}
	elseif ($device.OperatingSystem -eq "Android") {
		$category = "Phone"
	}
	else {
		$category = "Uncategorised"
	}

	$myObject = [PSCustomObject]@{
		FullName    = $device.UserDisplayName.replace(",", "")
		"Asset Name"   = $device.DeviceName.replace(",", "")
		"Asset Tag"    = $device.SerialNumber.replace(",", "")
		Email       = $device.EmailAddress.replace(",", "")
		IMEI        = $device.Imei.replace(",", "")
		"Phone Number" = $device.PhoneNumber.replace(",", "")
		Manufacturer = $device.Manufacturer.replace(",", "")
		"Model Name"   = $device.Model.replace(",", "")
		"Operating System" = "$($device.OperatingSystem) $($device.OSVersion)".replace(",", "")
		"Last User"    = $user.DisplayName.replace(",", "")
		Location    = $user.OfficeLocation.replace(",", "")
		Category	= $category.replace(",", "")
	}

	# Does the record have a serial number?
	if ( $device.AssetTag -ne "" )
	{
		$formatted_devices += $myObject
	}
}

$formatted_devices | Export-CSV "exported.csv"
