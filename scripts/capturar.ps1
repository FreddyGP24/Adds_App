param(
    [Parameter(Mandatory=$true)]
    [ValidatePattern('^[a-zA-Z0-9_-]+$')]
    [string]$Nombre,
    [string]$Dispositivo = 'emulator-5554',
    [string]$Adb = "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe"
)
$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot
$captureDir = Join-Path $projectRoot 'docs\capturas'
New-Item -ItemType Directory -Force -Path $captureDir | Out-Null
& $Adb -s $Dispositivo shell screencap -p /sdcard/mesa-capture.png
if ($LASTEXITCODE -ne 0) { throw 'No se pudo capturar la pantalla del dispositivo.' }
& $Adb -s $Dispositivo pull /sdcard/mesa-capture.png (Join-Path $captureDir "$Nombre.png")
if ($LASTEXITCODE -ne 0) { throw 'No se pudo guardar la captura.' }
Write-Output "Captura guardada: docs\capturas\$Nombre.png"
