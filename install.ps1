# Chocolatey installieren, falls nicht vorhanden
if (!(Test-Path "C:\ProgramData\Chocolatey\choco.exe")) {
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

# Repository von GitHub klonen oder updaten
$repoPath = "$env:TEMP\choco-packages"
if (Test-Path $repoPath) {
    cd $repoPath
    git pull
} else {
    git clone https://github.com/ironbiff/dein-repo.git $repoPath
}

# Pakete aus der packages.config installieren
choco install $repoPath\packages.config -y
