@echo off
:: V0.1
:: Check for Administrator privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo This script must be run as Administrator.
    pause
    exit
)

echo Uninstalling Corsair iCUE...

:: Step 1: Kill iCUE Processes
echo Killing iCUE processes...
taskkill /IM "iCUE.exe" /F >nul 2>&1
taskkill /IM "Corsair.Service.exe" /F >nul 2>&1

:: Step 2: Delete iCUE Installation Files
echo Deleting iCUE installation files...
rmdir /S /Q "C:\Program Files\Corsair\Corsair iCUE5 Software"

:: Step 3: Clean Registry Entries
echo Cleaning Registry...
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Corsair" /f
reg delete "HKEY_CURRENT_USER\SOFTWARE\Corsair" /f

:: Step 4: Remove Corsair Service
echo Removing Corsair services...
sc delete "CorsairService" >nul 2>&1

:: Step 5: Delete Temp Files
echo Deleting temporary files...
del /s /q "%temp%\Corsair" >nul 2>&1
del /s /q "%appdata%\Corsair" >nul 2>&1
del /s /q "%localappdata%\Corsair" >nul 2>&1

:: Step 6: Prompt for Restart
set /p restart="All tasks completed. Do you want to restart the computer now? (y/n): "
if /i "%restart%"=="y" (
    echo Restarting the computer...
    shutdown /r /t 5
) else (
    echo Restart canceled. Please restart manually if needed.
)

exit
