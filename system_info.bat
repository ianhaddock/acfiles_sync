@ECHO OFF
setlocal
:: This batch file will show system information
:: src: https://www.windowscentral.com/how-create-and-run-batch-file-windows-10

TITLE My System info
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