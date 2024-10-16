# Path to the registry key
$registryPath = "HKLM:\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters"
# Name of the registry value
$valueName = "EnablemDNS"
# Desired value
$desiredValue = 0

# Check if the registry key exists
if (-not (Test-Path $registryPath)) {
    Write-Host "Registry path does not exist: $registryPath" -ForegroundColor Red
    exit 1
}

# Get the current value of the registry property
$currentValue = Get-ItemProperty -Path $registryPath -Name $valueName -ErrorAction SilentlyContinue

if ($null -eq $currentValue) {
    # If the registry value does not exist, create it with the desired value
    New-ItemProperty -Path $registryPath -Name $valueName -Value $desiredValue -PropertyType DWORD -Force | Out-Null
    Write-Warning "Not Compliant as registry value '$valueName' does not exist. Attempting to remediate..."
      Write-Host "Registry value '$valueName' created with value $desiredValue" -ForegroundColor Green
} elseif ($currentValue.$valueName -ne $desiredValue) {
    # If the registry value exists but is not the desired value, set it to the desired value
    Set-ItemProperty -Path $registryPath -Name $valueName -Value $desiredValue
    Write-Warning "Not Compliant as registry value '$valueName' is not set to '0'. Attempting to remediate..."
    Write-Host "Registry value '$valueName' updated to value $desiredValue" -ForegroundColor Green
} else {
    Write-Host "Registry value '$valueName' already set to $desiredValue" -ForegroundColor Green
}

# Check if the value is compliant
if ($desiredValue -eq 0) {
    Write-Host "COMPLIANT: mDNS is disabled." -ForegroundColor Green
}