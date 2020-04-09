@echo off
cd \

set errormsg=ERROR:

set exe=.exe
set ps=.ps1

set vscodeurl="https://az764295.vo.msecnd.net/stable/2aae1f26c72891c399f860409176fe435a154b13/VSCodeUserSetup-x64-1.44.0.exe"


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

>null 2>&1 %vscodedir%\Program\bin\code --install-extension adelphes.android-dev-ext & >null 2>&1 %vscodedir%\Program\bin\code --install-extension aeschli.vscode-css-formatter & >null 2>&1 %vscodedir%\Program\bin\code --install-extension bat-snippets.bat-snippets & >null 2>&1 %vscodedir%\Program\bin\code --install-extension CAPTNCAPS.ue4-snippets & >null 2>&1 %vscodedir%\Program\bin\code --install-extension docsmsft.docs-markdown & >null 2>&1 %vscodedir%\Program\bin\code --install-extension forevolve.git-extensions-for-vs-code & >null 2>&1 %vscodedir%\Program\bin\code --install-extension foxundermoon.shell-format & >null 2>&1 %vscodedir%\Program\bin\code --install-extension lextudio.restructuredtext & >null 2>&1 %vscodedir%\Program\bin\code --install-extension mitaki28.vscode-clang & >null 2>&1 %vscodedir%\Program\bin\code --install-extension mpotthoff.vscode-android-webview-debug & >null 2>&1 %vscodedir%\Program\bin\code --install-extension ms-dotnettools.csharp & >null 2>&1 %vscodedir%\Program\bin\code --install-extension ms-python.python & >null 2>&1 %vscodedir%\Program\bin\code --install-extension ms-vscode.cpptools & >null 2>&1 %vscodedir%\Program\bin\code --install-extension msjsdiag.debugger-for-chrome & >null 2>&1 %vscodedir%\Program\bin\code --install-extension qinjia.view-in-browser & >null 2>&1 %vscodedir%\Program\bin\code --install-extension shd101wyy.markdown-preview-enhanced & >null 2>&1 %vscodedir%\Program\bin\code --install-extension sibiraj-s.vscode-scss-formatter





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

/LOADINF="C:\AV\Games\GettingStarted\Programming\Settings\Config.asf"
