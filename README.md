# Chocolatey Paket-Installation mit GitHub

Dieses Repository enthält eine Liste von Chocolatey-Paketen, die auf einem Windows-PC installiert werden können. Die Pakete werden über eine `packages.config` verwaltet und mit einem PowerShell-Skript automatisch installiert.

## ✨ Funktionen
- Automatische Installation und Aktualisierung von Software mit Chocolatey
- Sicherstellen, dass Git installiert ist
- Klonen oder Aktualisieren des Repositorys
- Einfache Verwaltung der Paketliste über GitHub
- Einzeilige Installation auf jedem Windows-PC

## ♻ Voraussetzungen
- Windows 10 oder höher
- Administratorrechte

## 🛠 Installation
1. Öffne eine **PowerShell-Konsole als Administrator**
2. Führe folgenden Befehl aus:
   ```powershell
   Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/ironbiff/chocolatey/main/install.ps1'))
   ```

Das Skript führt folgende Schritte aus:
1. Installiert Chocolatey, falls es nicht vorhanden ist
2. Installiert Git, falls es nicht vorhanden ist
3. Klont das Repository oder aktualisiert es, falls es bereits existiert
4. Prüft, ob `packages.config` vorhanden ist und installiert die Pakete

## 📂 Pakete verwalten
Die installierten Pakete sind in der Datei [`packages.config`](packages.config) definiert. Um neue Pakete hinzuzufügen oder zu entfernen:
1. Bearbeite die `packages.config`-Datei in diesem Repository
2. Speichere die Änderungen und pushe sie nach GitHub
3. Führe das Installationsskript erneut aus, um die Änderungen auf dem Zielsystem anzuwenden

## 🚀 Beispiel `packages.config`
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

## ⚙ Automatische Updates einrichten
Falls du das regelmäßig ausführen willst, kannst du das Skript als geplante Aufgabe (`taskschd.msc`) unter Windows hinzufügen. Alternativ kannst du es auch über eine Gruppenrichtlinie (`GPO`) automatisieren.

## 👌 Fertig!
Jetzt kannst du ganz einfach neue Windows-Systeme mit deinen bevorzugten Anwendungen ausstatten. 🚀

