<#
    .DESCRIPTION
    Installs the temporary Packer SSH public key for the build account.
#>

param(
    [Parameter(Mandatory = $true)]
    [string]$Username
)

Set-StrictMode -Version Latest
$ProgressPreference = 'SilentlyContinue'
$ErrorActionPreference = 'Stop'

$keyFile = 'E:\packer-ssh-authorized-key.txt'
$sshDir = Join-Path "C:\Users\$Username" '.ssh'
$authorizedKeys = Join-Path $sshDir 'authorized_keys'

if (-not (Test-Path -LiteralPath $keyFile)) {
    throw "Packer SSH public key file was not found: $keyFile"
}

$publicKey = (Get-Content -LiteralPath $keyFile -Raw).Trim()
if ($publicKey -notmatch '^ssh-ed25519\s+') {
    throw 'Packer SSH public key is not an Ed25519 authorized_keys entry'
}

New-Item -Path $sshDir -ItemType Directory -Force | Out-Null
Set-Content -LiteralPath $authorizedKeys -Value $publicKey -Encoding ascii
icacls.exe $sshDir /inheritance:r /grant:r "${Username}:(OI)(CI)F" | Out-Null
icacls.exe $authorizedKeys /inheritance:r /grant:r "${Username}:F" | Out-Null
