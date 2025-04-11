# Chocolatey & Winget Paket-Installation mit GitHub

Dieses Repository enthält eine Liste von Chocolatey- und Winget-Paketen, die auf einem Windows-PC installiert werden können. Die Pakete werden über eine `choco-packages.config` (für Chocolatey) und `winget-packages.config` (für Winget) verwaltet und mit einem PowerShell-Skript automatisch installiert.

---

## ✨ Funktionen

- Automatische Installation und Aktualisierung von Software mit Chocolatey und Winget  
- Sicherstellen, dass Git installiert ist  
- Klonen oder Aktualisieren des Repositorys  
- Einfache Verwaltung der Paketliste über GitHub  
- Einzeilige Installation auf jedem Windows-PC  

---

## ♻ Voraussetzungen

- Windows 10 oder höher  
- Administratorrechte  

---

## 🛠 Installation

1. Öffne eine **PowerShell-Konsole als Administrator**
2. Führe folgenden Befehl aus:

   ```powershell
   Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/ironbiff/chocolatey/main/install.ps1'))
   ``` 


Das Skript führt folgende Schritte aus:

Installiert Chocolatey, falls es nicht vorhanden ist

Installiert Git, falls es nicht vorhanden ist

Klont das Repository oder aktualisiert es, falls es bereits existiert

Prüft, ob choco-packages.config vorhanden ist und installiert die Pakete mit Chocolatey

Prüft, ob winget-packages.config vorhanden ist und installiert die Pakete mit Winget

## 📂 Pakete verwalten
### Chocolatey
Die installierten Pakete sind in der Datei choco-packages.config definiert.
Um neue Pakete hinzuzufügen oder zu entfernen:

Bearbeite die choco-packages.config-Datei in diesem Repository

Speichere die Änderungen und pushe sie nach GitHub

Führe das Installationsskript erneut aus, um die Änderungen auf dem Zielsystem anzuwenden

Beispiel:

```xml
<?xml version="1.0" encoding="utf-8"?>
<packages>
    <package id="git" />
    <package id="googlechrome" />
    <package id="firefox" />
    <package id="7zip" />
    <package id="notepadplusplus" />
</packages>
```

### Winget
Die Pakete aus dem Microsoft Store oder anderen Winget-Quellen befinden sich in der Datei winget-packages.config.
Diese Datei enthält pro Zeile eine Paket-ID oder App-ID.

Beispiel:
```xml
Spotify.Spotify
Microsoft.PowerToys
9WZDNCRFJ3TJ # Xbox Game Bar
```

## ⚙ Automatische Updates einrichten
Falls du das regelmäßig ausführen willst, kannst du das Skript als geplante Aufgabe (taskschd.msc) unter Windows hinzufügen.
Alternativ kannst du es auch über eine Gruppenrichtlinie (GPO) automatisieren.

👌 Fertig!
Jetzt kannst du ganz einfach neue Windows-Systeme mit deinen bevorzugten Anwendungen ausstatten – ob aus dem Web oder aus dem Microsoft Store! 🚀
