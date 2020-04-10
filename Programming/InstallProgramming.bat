@echo off
cd \

set errormsg=ERROR:

set exe=.exe
set msi=.msi
set ps=.ps1

set vscodeurl="https://az764295.vo.msecnd.net/stable/2aae1f26c72891c399f860409176fe435a154b13/VSCodeUserSetup-x64-1.44.0.exe"
set vimurl="https://ftp.nluug.nl/pub/vim/pc/gvim82.exe"


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


set vscodedir=%frameworkdir%\VSCode
>nul 2>&1 mkdir "%vscodedir%"

set vscodeexe=%tempdir%\vscode%exe%
set vscodeps="%tempdir%\vscode%ps%"

echo $client = new-object System.Net.WebClient;$client.DownloadFile(%vscodeurl%,"%vscodeexe%");> %vscodeps%
start /wait powershell -windowstyle hidden -file %vscodeps%
del /f %vscodeps%

start /wait %vscodeexe% /SP- /VERYSILENT /SUPPRESSMSGBOXES /CURRENTUSER /LOG="%logdir%\VSCodeLog" /NOCANCEL /NORESTART /DIR="%vscodedir%\Program" /MERGETASKS="!runcode"
del /f "%vscodeexe%"


set vimexe=%tempdir%\vim%exe%
set vimps="%tempdir%\vim%ps%"

echo $client = new-object System.Net.WebClient;$client.DownloadFile(%vimurl%,"%vimexe%");> %vimps%
start /wait powershell -windowstyle hidden -file %vimps%
del /f %vimps%

start /wait %vimexe% /LANG=en /TYPE=FULL /S
del /f "%vimexe%"


pause
pause
pause
pause


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
