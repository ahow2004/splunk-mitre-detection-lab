# setup.ps1
Write-Host "`nStarting Splunk MITRE Lab Setup..." -ForegroundColor Cyan

# Define paths
$ufPath = "C:\Program Files\SplunkUniversalForwarder"
$localConfPath = "$ufPath\etc\system\local"
$repoRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition
$lookupSrc = Join-Path $repoRoot "mitre_lookup\mitre_lookup.csv"
$inputsSrc = Join-Path $repoRoot "configs\inputs.conf"

# Check if Splunk UF is installed
if (-Not (Test-Path $ufPath)) {
    Write-Error "Splunk Universal Forwarder is not installed at $ufPath"
    exit 1
}

# Copy inputs.conf
if (Test-Path $inputsSrc) {
    Copy-Item $inputsSrc -Destination $localConfPath -Force
    Write-Host "✓ Copied inputs.conf to $localConfPath"
} else {
    Write-Warning "inputs.conf not found in $inputsSrc"
}

# Restart Splunk UF
$binPath = "$ufPath\bin"
if (Test-Path "$binPath\splunk.exe") {
    Write-Host "Restarting Splunk Universal Forwarder..."
    & "$binPath\splunk.exe" restart
} else {
    Write-Warning "Could not find splunk.exe at $binPath"
}

# Reminder to upload lookup manually
Write-Host "`nReminder:" -ForegroundColor Yellow
Write-Host "→ You still need to upload 'mitre_lookup.csv' in Splunk Web:"
Write-Host "  Settings → Lookups → Lookup table files → Add new"
Write-Host "  Then define it under Lookup Definitions as 'mitre_lookup'"
Write-Host "`nSetup complete." -ForegroundColor Green
