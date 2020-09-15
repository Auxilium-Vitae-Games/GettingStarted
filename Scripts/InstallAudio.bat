@echo off
cd \

set errormsg=ERROR:

set exe=.exe
set ps=.ps1

set audaurl="https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/audacity/audacity-win-2.0.5.exe"


if not "%1"=="" (
    set frameworkdir=%1
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
set frameworkdir=%selectedpathframework%
:noinputsframework

set tempdir=%frameworkdir%\Temp
>nul 2>&1 mkdir %tempdir%

set logdir=%tempdir%\Log
>nul 2>&1 mkdir "%logdir%"


set audadir=%frameworkdir%\Audacity
>nul 2>&1 mkdir "%audadir%"

set audaexe=%tempdir%\auda%exe%
set audaps="%tempdir%\auda%ps%"

echo $client = new-object System.Net.WebClient;$client.DownloadFile(%audaurl%,"%audaexe%");> %audaps%
start /wait powershell -windowstyle hidden -file %audaps%
del /f %audaps%

start /wait %audaexe% /SP- /VERYSILENT /SUPPRESSMSGBOXES /CURRENTUSER /LOG="%logdir%\AudacityLog" /NOCANCEL /NORESTART /DIR="%audadir%\Program"
del /f "%audaexe%"


if not "%2"=="" (
    set gitrepository=%2
    goto:noinputsgit
)
:notselectedgit
set ps_cmdgit=powershell "Add-Type -AssemblyName System.windows.forms|Out-Null;$f=New-Object System.Windows.Forms.FolderBrowserDialog;$f.ShowDialog()|Out-Null;$f.SelectedPath"
for /f "delims=" %%I in ('%ps_cmdgit%') do set "selectedpathgit=%%I"
if not defined selectedpathgit (
    echo.
    echo %errormsg% Did not choose a folder.
    echo.
    goto:notselectedgit
)
set gitrepository=%selectedpathgit%
:noinputsgit

/LOADINF="%gitrepository%\Programming\Config\Config.asf"
