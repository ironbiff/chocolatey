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

# Repository-Verzeichnis festlegen
$repoPath = "$env:TEMP\chocolatey"

# Prüfen, ob das Repository existiert und gültig ist
if (Test-Path "$repoPath\.git") {
    Write-Host "Aktualisiere bestehendes Repository..." -ForegroundColor Green
    Set-Location $repoPath
    git pull
} else {
    # Falls nicht, neu klonen
    Write-Host "Klone Repository..." -ForegroundColor Green
    Remove-Item -Recurse -Force $repoPath -ErrorAction SilentlyContinue
    git clone https://github.com/ironbiff/chocolatey.git $repoPath
    Set-Location $repoPath
}

# === Choco Pakete installieren und prüfen, ob die packages.config existiert
$packageConfig = "$repoPath\packages.config"
if (Test-Path $packageConfig) {
    Write-Host "Installiere Pakete aus packages.config..." -ForegroundColor Cyan
    choco install $packageConfig -y
    Write-Host "Installation abgeschlossen!" -ForegroundColor Green
} else {
    Write-Host "FEHLER: packages.config wurde nicht gefunden!" -ForegroundColor Red
    exit 1
}

# === Winget Pakete installieren ===
$wingetFile = "$repoPath\winget-packages.config"
if (Test-Path $wingetFile) {
    Write-Host "`n📦 Installiere Pakete aus winget-packages.config..." -ForegroundColor Cyan
    Get-Content $wingetFile | ForEach-Object {
        $pkg = $_.Trim()
        if ($pkg -and -not $pkg.StartsWith("#")) {
            Write-Host "→ Installiere $pkg über winget..."
            winget install --id "$pkg" --accept-source-agreements --accept-package-agreements -e
        }
    }
} else {
    Write-Host "⚠ winget-packages.config nicht gefunden – überspringe Winget-Installation." -ForegroundColor Yellow
}

Write-Host "`n✅ Alle Installationen abgeschlossen!" -ForegroundColor Green
