# setup.ps1
Write-Host "`nStarting Splunk MITRE Lab Setup..." -ForegroundColor Cyan

# Function to locate splunk.exe
function Find-SplunkUF {
    Write-Host "Searching for splunk.exe..." -NoNewline
    $paths = Get-ChildItem -Path "$env:SystemDrive\" -Recurse -Filter "splunk.exe" -ErrorAction SilentlyContinue -Force |
        Where-Object { $_.FullName -like "*UniversalForwarder*" -and $_.FullName -notlike "*bin\python*" }

    if ($paths.Count -eq 0) {
        Write-Error "`nCould not find a Splunk Universal Forwarder installation on this machine."
        exit 1
    }

    # Use first match
    return Split-Path -Parent $paths[0].FullName
}

# Locate UF
$binPath = Find-SplunkUF
$ufRoot = Split-Path -Parent $binPath
$localConfPath = "$ufRoot\etc\system\local"

# Paths from repo
$repoRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition
$inputsSrc = Join-Path $repoRoot "configs\inputs.conf"
$lookupSrc = Join-Path $repoRoot "mitre_lookup\mitre_lookup.csv"

# Copy inputs.conf
if (Test-Path $inputsSrc) {
    Copy-Item $inputsSrc -Destination $localConfPath -Force
    Write-Host "`n✓ Copied inputs.conf to $localConfPath"
} else {
    Write-Warning "inputs.conf not found in $inputsSrc"
}

# Restart the forwarder
Write-Host "`nRestarting Splunk Universal Forwarder..."
& "$binPath\splunk.exe" restart

# Manual lookup reminder
Write-Host "`nReminder:" -ForegroundColor Yellow
Write-Host "→ You still need to upload 'mitre_lookup.csv' via Splunk Web:"
Write-Host "  Settings → Lookups → Lookup table files → Add new"
Write-Host "  Then define it under Lookup Definitions as 'mitre_lookup'"
Write-Host "`nSetup complete." -ForegroundColor Green
