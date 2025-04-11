# Sicherstellen, dass das Skript mit Administratorrechten ausgeführt wird
$currUser = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = New-Object Security.Principal.WindowsPrincipal($currUser)
if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Dieses Skript muss als Administrator ausgeführt werden!" -ForegroundColor Red
    exit 1
}

Write-Host "`n🚀 Starte Installationsprozess..." -ForegroundColor Cyan

# === GitHub Repo Pfad ===
$repoUrl = "https://github.com/ironbiff/chocolatey.git"
$repoPath = "$env:USERPROFILE\choco-setup"

# === Chocolatey installieren, falls nötig ===
if (!(Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "➡ Installiere Chocolatey..." -ForegroundColor Green
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
} else {
    Write-Host "✅ Chocolatey ist bereits installiert."
}

# === Git installieren, falls nötig ===
if (!(Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "➡ Installiere Git..." -ForegroundColor Green
    choco install git -y
} else {
    Write-Host "✅ Git ist bereits installiert."
}

# === Repository klonen oder aktualisieren ===
if (Test-Path $repoPath) {
    Write-Host "🔄 Aktualisiere bestehendes Repository..."
    Set-Location $repoPath
    git pull
} else {
    Write-Host "📥 Klone Repository..."
    git clone $repoUrl $repoPath
    Set-Location $repoPath
}

# === Chocolatey Pakete installieren ===
$chocoFile = "$repoPath\choco-packages.config"
if (Test-Path $chocoFile) {
    Write-Host "`n📦 Installiere Pakete aus choco-packages.config..." -ForegroundColor Cyan
    choco install $chocoFile -y
} else {
    Write-Host "⚠ choco-packages.config nicht gefunden – überspringe Chocolatey-Installation." -ForegroundColor Yellow
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
