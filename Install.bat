@echo off
cd \

set errormsg=ERROR:

set exe=.exe
set zip=.zip
set ps=.ps1

set chromeurl="https://dl.google.com/tag/s/appguid%%3D%%7B8A69D345-D564-463C-AFF1-A69D9E530F96%%7D%%26iid%%3D%%7B7A7F685F-11EB-E727-CA52-C26A6CF7755C%%7D%%26lang%%3Den%%26browser%%3D4%%26usagestats%%3D1%%26appname%%3DGoogle%%2520Chrome%%26needsadmin%%3Dprefers%%26ap%%3Dx64-stable-statsdef_1%%26installdataindex%%3Dempty/update2/installers/ChromeSetup.exe"
set zurl="https://www.7-zip.org/a/7z1900-x64.exe"
set gitexturl="https://github.com/gitextensions/gitextensions/releases/download/v3.3.1/GitExtensions-pdbs-3.3.1.7897.zip"
set vsurl="https://download.visualstudio.microsoft.com/download/pr/ac28b571-7709-4635-83d0-6277d6102ecb/893084d903e5d490b248099fdbb341b684fe026435ff2824f6e66f98fb0d1070/vs_Community.exe"

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


set chromedir=%frameworkdir%\Chrome
>nul 2>&1 mkdir %chromedir%

set chromeexe=%tempdir%\chrome%exe%
set chromeps="%tempdir%\chrome%ps%"

echo $client = new-object System.Net.WebClient;$client.DownloadFile(%chromeurl%,"%chromeexe%");> %chromeps%
start /wait powershell -windowstyle hidden -file %chromeps%
del /f %chromeps%

start /wait %chromeexe% /install /silent
del /f "%chromeexe%"


set zdir=%frameworkdir%\7Zip
>nul 2>&1 mkdir "%zdir%"

set zexe=%tempdir%\7zip%exe%
set zps="%tempdir%\7zip%ps%"

echo $client = new-object System.Net.WebClient;$client.DownloadFile(%zurl%,"%zexe%");> %zps%
start /wait powershell -windowstyle hidden -file %zps%
del /f %zps%

start /wait %zexe% /S /D="%zdir%\Program"
del /f "%zexe%"

echo.%PATH%|findstr /C:"%zdir%\Program" >nul 2>&1 || >nul setx /m PATH "%PATH%;%zdir%\Program"


set gitextdir=%frameworkdir%\GitExtensions
>nul 2>&1 mkdir %gitextdir%

set gitextzip=%tempdir%\gitext%zip%
set gitextps="%tempdir%\gitext%ps%"

echo $client = new-object System.Net.WebClient;$client.DownloadFile(%gitexturl%,"%gitextzip%");> %gitextps%
start /wait powershell -windowstyle hidden -file %gitextps%
del /f %gitextps%

start /wait %zdir%\Program\7z x -bd -y -o"%gitextdir%\Program" %gitextzip% 
del /f "%gitextzip%"

>nul 2>&1 xcopy /y /s "%gitextdir%\Program\GitExtensions" "%gitextdir%\Program"

>nul 2>&1 del /s /q "%gitextdir%\Program\GitExtensions\*"
>nul 2>&1 rmdir /s /q "%gitextdir%\Program\GitExtensions"

echo.%PATH%|findstr /C:"%gitextdir%\Program" >nul 2>&1 || >nul setx /m PATH "%PATH%;%gitextdir%\Program"

powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('%ProgramData%\Microsoft\Windows\Start Menu\Programs\GitExtensions.lnk');$s.TargetPath='%gitextdir%\Program\GitExtensions.exe';$s.Save()"


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


%gitextdir%\Program\gitextensions browse "%gitrepository%"


set vsdir=%frameworkdir%\VS
>nul 2>&1 mkdir "%vsdir%"

set vsexe=%tempdir%\vs%exe%
set vsps="%tempdir%\vs%ps%"

echo $client = new-object System.Net.WebClient;$client.DownloadFile(%vsurl%,"%vsexe%");> %vsps%
start /wait powershell -windowstyle hidden -file %vsps%
del /f %vsps%

start /wait %vsexe% --path install="%vsdir%\Program" --path cache="%vsdir%\Cache" --path shared="%vsdir%\Shared" --config "%gitrepository%\UE\Config\.vsconfig" --locale En-us --quiet --norestart --wait
del /f "%vsexe%"


call %gitrepository%\UE\Program\Setup.bat --force
call %gitrepository%\UE\Program\GenerateProjectFiles.bat -2019
call %gitrepository%\UE\Program\Engine\Binaries\DotNET\UnrealBuildTool.exe -Target="UE4Editor Win64 Development" -Target="ShaderCompileWorker Win64 Development -Quiet" -WaitMutex -FromMsBuild -2019
