@echo off
cd \

set errormsg=ERROR:
set nodownloadmsg=Waiting for downloading file. DO NOT CLOSE!

set exe=.exe
set ps=.ps1

set giturl="https://github.com/git-for-windows/git/releases/download/v2.26.0.windows.1/Git-2.26.0-64-bit.exe"
set gitlfsurl="https://github.com/git-lfs/git-lfs/releases/download/v2.10.0/git-lfs-windows-v2.10.0.exe"

set gitrepository="https://github.com/AuxiliumVitaeGames/GettingStarted.git"


set /p gitname=Name of project ("GettingStarted" by default): 
if "%gitname%"=="" (
    set gitname=GettingStarted
)


:notselected
set ps_cmd=powershell "Add-Type -AssemblyName System.windows.forms|Out-Null;$f=New-Object System.Windows.Forms.FolderBrowserDialog;$f.ShowDialog()|Out-Null;$f.SelectedPath"
for /f "delims=" %%I in ('%ps_cmd%') do set "selectedpath=%%I"
if not defined selectedpath (
    echo.
    echo %errormsg% Did not choose a folder.
    echo.
    goto:notselected
)
set frameworkdir=%selectedpath%\ProgramData
>nul 2>&1 mkdir %frameworkdir%

set projectsdir=%selectedpath%\Projects
>nul 2>&1 mkdir %projectsdir%

set tempdir=%frameworkdir%\Temp
>nul 2>&1 mkdir %tempdir%

set logdir=%tempdir%\Log
>nul 2>&1 mkdir "%logdir%"


set gitdir=%frameworkdir%\Git
>nul 2>&1 mkdir "%gitdir%"

set gitexe=%tempdir%\git%exe%
set gitps="%tempdir%\git%ps%"

echo $client = new-object System.Net.WebClient;$client.DownloadFile(%giturl%,"%gitexe%");> %gitps%
start /wait powershell -windowstyle hidden -file %gitps%
del /f %gitps%

start /wait %gitexe% /SP- /VERYSILENT /SUPPRESSMSGBOXES /CURRENTUSER /LOG="%logdir%\GitLog" /NOCANCEL /NORESTART /DIR="%gitdir%\Program"
del /f "%gitexe%"


set gitlfsdir=%frameworkdir%\GitLFS
>nul 2>&1 mkdir %gitlfsdir%

set gitlfsexe=%gitlfsdir%\gitlfs%exe%
set gitlfsps="%gitlfsdir%\gitlfs%ps%"

echo $client = new-object System.Net.WebClient;$client.DownloadFile(%gitlfsurl%,"%gitlfsexe%");> %gitlfsps%
start /wait powershell -windowstyle hidden -file %gitlfsps%
del /f %gitlfsps%

start /wait %gitlfsexe% /SP- /VERYSILENT /SUPPRESSMSGBOXES /CURRENTUSER /LOG="%logdir%\GitLFSLog" /NOCANCEL /NORESTART /DIR="%gitlfsdir%\Program"
del /f "%gitlfsexe%"


%gitdir%\Program\cmd\git.exe clone --recursive %gitrepository% "%projectsdir%\%gitname%"
%gitdir%\Program\cmd\git.exe -C "%projectsdir%\%gitname%" fetch --all
%gitdir%\Program\cmd\git.exe -C "%projectsdir%\%gitname%" pull origin master


call "%frameworkdir%\%gitname%\Scripts\Install.bat" %frameworkdir% %projectsdir%\%gitname%
