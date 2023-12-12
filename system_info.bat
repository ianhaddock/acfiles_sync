@ECHO OFF
setlocal
:: This batch file will show system information 

TITLE My System info

ECHO This script will gather system information. Proceed?
SET /P AREYOUSURE=Are you sure (Y/[N])?
IF /I "%AREYOUSURE%" NEQ "Y" GOTO END

ECHO -------
ECHO Windows info
ECHO -------
systeminfo | findstr /C:"OS Name"
systeminfo | findstr /c:"OS Version"
systeminfo | findstr /c:"System Type"

:: Hardware

ECHO -------
ECHO Hardware info
ECHO -------
systeminfo | findstr /c:"Total Physical Memory"
wmic cpu get Name
wmic diskdrive get name,model,size
wmic path win32_videocontroller get Name
wmic path win32_VideoController get CurrentHorizontalResolution,CurrentVerticalResolution

:: networking

ECHO -------
ECHO Network info
ECHO -------

ipconfig | findstr IPv4
ipconfig | findstr IPv6

:END

endlocal
PAUSE