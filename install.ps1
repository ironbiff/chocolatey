# Sicherstellen, dass das Skript mit Administratorrechten ausgeführt wird
$currUser = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = New-Object Security.Principal.WindowsPrincipal($currUser)
if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Dieses Skript muss als Administrator ausgeführt werden!" -ForegroundColor Red
    exit 1
}

# Chocolatey installieren, falls nicht vorhanden
if (!(Test-Path "C:\ProgramData\Chocolatey\choco.exe")) {
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    RefreshEnv
}

# Git installieren, falls nicht vorhanden
if (!(Get-Command git -ErrorAction SilentlyContinue)) {
    choco install git -y
    $env:Path += ";C:\Program Files\Git\bin"
    RefreshEnv
}

# Repository von GitHub klonen oder updaten
$repoPath = "$env:TEMP\chocolatey"
if (Test-Path $repoPath) {
    Write-Host "Aktualisiere bestehendes Repository..." -ForegroundColor Green
    cd $repoPath
    git pull
} else {
    Write-Host "Klone Repository..." -ForegroundColor Green
    git clone https://github.com/ironbiff/chocolatey.git $repoPath
}

# Pakete aus der packages.config installieren
Write-Host "Installiere Pakete aus packages.config..." -ForegroundColor Cyan
choco install $repoPath\packages.config -y

Write-Host "Installation abgeschlossen!" -ForegroundColor Green
