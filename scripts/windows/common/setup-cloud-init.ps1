# Placeholder - will be replaced by setup-cloud-init.ps1 which runs at first boot
# One script handles both install-time setup (SetupComplete hook) and first-boot cloud-init
Write-Output "Setting up first-boot cloud-init handler"

$scriptDir = "$env:ProgramData\cloud-init-setup"
New-Item -ItemType Directory -Force -Path $scriptDir | Out-Null

@'
# First-boot script: reads cloud-init seed ISO and injects SSH keys/password for Administrator
$seedDrive = Get-Volume | Where-Object { $_.FileSystemLabel -eq "cidata" } | Select-Object -First 1
if (-not $seedDrive) {
    $seedDrive = Get-Volume | Where-Object { $_.FileSystemLabel -eq "CIDATA" } | Select-Object -First 1
}
if (-not $seedDrive) {
    Write-Output "No cidata volume found, skipping cloud-init"
    exit 0
}

$driveRoot = "$($seedDrive.DriveLetter):"
Write-Output "Found seed drive at $driveRoot"

$userDataPath = Join-Path $driveRoot "user-data"
if (-not (Test-Path $userDataPath)) { $userDataPath = Join-Path $driveRoot "USER_DATA" }
if (-not (Test-Path $userDataPath)) { $userDataPath = Join-Path $driveRoot "user_data" }

$metaDataPath = Join-Path $driveRoot "meta-data"
if (-not (Test-Path $metaDataPath)) { $metaDataPath = Join-Path $driveRoot "META_DATA" }
if (-not (Test-Path $metaDataPath)) { $metaDataPath = Join-Path $driveRoot "meta_data" }

if (-not (Test-Path $userDataPath)) {
    Write-Output "No user-data found on seed drive"
    exit 0
}

Write-Output "Reading user-data from $userDataPath"
$userData = Get-Content $userDataPath -Raw

# Parse ssh_authorized_keys from YAML-like user-data
$keys = @()
$inKeys = $false
foreach ($line in ($userData -split "[\r\n]+")) {
    if ($line -match '^\s*ssh_authorized_keys\s*:') { $inKeys = $true; continue }
    if ($inKeys) {
        if ($line -match '^\s*-\s+(ssh-\S+\s+\S+)') { $keys += $matches[1] }
        elseif ($line -match '^\s*-\s+"(ssh-\S+\s+\S+)"') { $keys += $matches[1] }
        elseif ($line -notmatch '^\s*-' -and $line -notmatch '^\s*$') { $inKeys = $false }
    }
}

# Parse password from user-data
$password = $null
if ($userData -match 'password\s*:\s*(\S+)') {
    $password = $matches[1]
}

# Parse hostname
$hostname = $null
if ($userData -match 'hostname\s*:\s*(\S+)') {
    $hostname = $matches[1]
}

# Apply SSH keys to Administrator
if ($keys.Count -gt 0) {
    $sshDir = "$env:SystemDrive\Users\Administrator\.ssh"
    New-Item -ItemType Directory -Force -Path $sshDir | Out-Null
    $authFile = Join-Path $sshDir "authorized_keys"
    $keys | Out-File -FilePath $authFile -Encoding ASCII
    Write-Output "Injected $($keys.Count) SSH key(s) for Administrator"

    # Fix permissions on authorized_keys (required by OpenSSH)
    icacls $authFile /inheritance:r /grant "SYSTEM:(R)" /grant "Administrators:(R)" /grant "Administrator:(R)" 2>$null

    # Restart sshd to pick up changes
    Restart-Service sshd -ErrorAction SilentlyContinue
}

# Apply password
if ($password) {
    net user Administrator "$password"
    Write-Output "Set Administrator password from cloud-init"
}

# Apply hostname
if ($hostname) {
    Rename-Computer -NewName $hostname -Force -ErrorAction SilentlyContinue
}

Write-Output "First-boot cloud-init setup complete"
'@ | Set-Content -Path "$scriptDir\first-boot-setup.ps1" -Encoding ASCII

# Register as a one-time SetupComplete script (runs after OOBE on first boot after sysprep)
$setupCompleteDir = "$env:SystemRoot\Setup\Scripts"
New-Item -ItemType Directory -Force -Path $setupCompleteDir | Out-Null

# Create SetupComplete.cmd that calls our PowerShell script
@"
@echo off
powershell.exe -ExecutionPolicy Bypass -File "$scriptDir\first-boot-setup.ps1" >> "$scriptDir\first-boot.log" 2>&1
"@ | Set-Content -Path "$setupCompleteDir\SetupComplete.cmd" -Encoding ASCII

Write-Output "First-boot cloud-init handler installed"
