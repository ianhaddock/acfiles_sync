:: This script uses robocopy to sync files to dest_path
:: Logs are used to improve multithread performance
:: v1: 20231211

@ECHO OFF

TITLE 'Robocopy Files'

:: use local vars
setlocal

:: robosync options
set "robocopy_options=/COPY:DAT /DCOPY:DAT /S /Z /MT /MIR"
set "robocopy_log_path=C:\Users\admin\Documents\batch_files"

:: source paths
set "docs_src=C:\Users\admin\Documents"
set "appuser_src=C:\Users\admin\AppData\Local\AcTools Content Manager"
set "assetto_src=C:\Program Files (x86)\Steam\steamapps\common\assettocorsa"

:: destination paths
SET "dest_path=Z:\Assetto Corsa"
set "docs_dest=%dest_path%\Documents"
set "appuser_dest=%dest_path%\AcTools Content Manager"
set "assetto_dest=%dest_path%\assettocorsa"

:: confirm before starting
ECHO:
ECHO This script uses robocopy to sync Assetto Corsa files to the %dest_path% Directory.
SET /P AREYOUSURE=Proceed (Y/[N])? 
IF /I "%AREYOUSURE%" NEQ "Y" (
    ECHO Exiting without syncing any files.
    PAUSE
    EXIT /B 0
)

:: sanity check source paths
IF NOT EXIST "%docs_src%" (
    ECHO ERROR: Path missing: %docs_src%
    PAUSE
    EXIT /B 1
)

IF NOT EXIST "%appuser_src%" (
    ECHO ERROR: Path missing: %appuser_src%
    PAUSE
    EXIT /B 1
)

:: path has parens. IF statement gets confused, escape ^ does not seem to satisfy.
::set "test_assetto_src=%assetto_src:)=^)%"
::set "test_assetto_src=%test_assetto_src:(=^(%"
::ECHO "%test_assetto_src%"
::IF NOT EXIST "%test_assetto_src%" (
::    ECHO ERROR: Path missing: %assetto_src%
::    PAUSE
::    EXIT /B 1
::)

:: create destination path
IF NOT EXIST "%dest_path%" mkdir "%dest_path%"

:: create log path
IF NOT EXIST "%robocopy_log_path%" mkdir "%robocopy_log_path%"

:: start file sync tasks
ECHO:
ECHO Syncing Documents folder
IF NOT EXIST "%docs_dest%" mkdir "%docs_dest%"
robocopy "%docs_src%" "%docs_dest%" %robocopy_options% /LOG:%robocopy_log_path%\robocopy_documents.log
:: Robocopy always fails on some files in Documents, so we only check for fatal error level: 16.
if ErrorLevel 16 (
    ECHO Something went wrong. 
    ECHO Robocopy errorlevel: %ErrorLevel% 
    PAUSE
    EXIT /B 1
)

ECHO:
ECHO Syncing ACTools Appuser Data
IF NOT EXIST "%appuser_dest%" mkdir "%appuser_dest%"
robocopy "%appuser_src%" "%appuser_dest%" %robocopy_options% /LOG:%robocopy_log_path%\robocopy_appuser.log
if ErrorLevel 8 (
    ECHO Something went wrong. 
    ECHO Robocopy errorlevel: %ErrorLevel% 
    PAUSE
    EXIT /B 1
)

ECHO:
ECHO Syncing Assetto Corsa Directory
IF NOT EXIST "%assetto_dest%" mkdir "%assetto_dest%"
robocopy "%assetto_src%" "%assetto_dest%" %robocopy_options% /LOG:%robocopy_log_path%\robocopy_assettocorsa.log
if ErrorLevel 8 (
    ECHO Something went wrong. 
    ECHO Robocopy errorlevel: %ErrorLevel% 
    PAUSE
    EXIT /B 1
)

ECHO:
ECHO Finished!
ECHO:

endlocal

PAUSE