$ErrorActionPreference = "Stop"

Write-Host "=== OOPS Windows / WSL bootstrap ===" -ForegroundColor Cyan

$principal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error "Run PowerShell as Administrator."
}

Write-Host "Updating WSL..."
wsl --update

Write-Host "Setting WSL2 as the default..."
wsl --set-default-version 2

$installed = (wsl --list --quiet) -replace "`0", "" | ForEach-Object { $_.Trim() }
if ($installed -contains "kali-linux") {
    Write-Host "Kali Linux is already installed." -ForegroundColor Green
} else {
    Write-Host "Installing Kali Linux..."
    wsl --install -d kali-linux
}

Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Restart Windows if WSL asks for it."
Write-Host "2. Open Kali Linux and create your Linux username/password."
Write-Host "3. Clone this repository inside Kali."
Write-Host "4. Run: chmod +x kali/*.sh"
Write-Host "5. Run: ./kali/setup-oops-tools.sh"
