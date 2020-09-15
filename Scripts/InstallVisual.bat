@echo off
cd \

set errormsg=ERROR:

set exe=.exe
set ps=.ps1

set gimpurl="https://download.gimp.org/mirror/pub/gimp/v2.10/windows/gimp-2.10.18-setup-2.exe"
set shotcuturl="https://github.com/mltframework/shotcut/releases/download/v20.04.12/shotcut-win64-200412.exe"


if "%3"=="y" (
    goto:nomodelingcheck
)
if "%3"=="n" (
    goto:nomodelingcheck
)

:modelingwrong
set /p modelingcheck=Do you want to install modeling apps? (y/n)  
if "%modelingcheck%"=="y" (
    goto:modelingwell
)
if "%modelingcheck%"=="n" (
    goto:modelingwell
)
echo %errormsg% Incorrect answer. Choose "y"(YES) or "n"(NO).
goto:modelingwrong
:modelingwell

:nomodelingcheck


if not "%1"=="" (
    set programDatadir=%1
    goto:noinputsframework
)
:notselectedframework
set ps_cmdframework=powershell "Add-Type -AssemblyName System.windows.forms|Out-Null;$f=New-Object System.Windows.Forms.FolderBrowserDialog;$f.ShowDialog()|Out-Null;$f.SelectedPath"
for /f "delims=" %%I in ('%ps_cmdframework%') do set "selectedpathframework=%%I"
if not defined selectedpathframework (
    echo.
    echo %errormsg% Did not choose a folder.
    echo.
    goto:notselectedframework
)
set programDatadir=%selectedpathframework%\ProgramData
>nul 2>&1 mkdir %programDatadir%
:noinputsframework

set tempdir=%programDatadir%\Temp
>nul 2>&1 mkdir %tempdir%

set logdir=%tempdir%\Log
>nul 2>&1 mkdir "%logdir%"


set gimpdir=%programDatadir%\GIMP
>nul 2>&1 mkdir "%gimpdir%"

set gimpexe=%tempdir%\gimp%exe%
set gimpps="%tempdir%\gimp%ps%"

echo $client = new-object System.Net.WebClient;$client.DownloadFile(%gimpurl%,"%gimpexe%");> %gimpps%
start /wait powershell -windowstyle hidden -file %gimpps%
del /f %gimpps%

start /wait %gimpexe% /SP- /VERYSILENT /SUPPRESSMSGBOXES /CURRENTUSER /LOG="%logdir%\GIMPLog" /NOCANCEL /NORESTART /DIR="%gimpdir%\Program"
del /f "%gimpexe%"


set shotcutdir=%programDatadir%\Shotcut
>nul 2>&1 mkdir "%shotcutdir%"

set shotcutexe=%tempdir%\shotcut%exe%
set shotcutps="%tempdir%\shotcut%ps%"

echo $client = new-object System.Net.WebClient;$client.DownloadFile(%shotcuturl%,"%shotcutexe%");> %shotcutps%
start /wait powershell -windowstyle hidden -file %shotcutps%
del /f %shotcutps%

start /wait %shotcutexe% /S /D=%shotcutdir%\Program
del /f "%shotcutexe%"


if "%modelingcheck%"=="y" (
    call %gitrepository%\Scripts\InstallVisualModeling.bat %programDatadir% %gitrepository%
)
