REM This file is the initialization to windows, creates the folder C:/term, creates a context file to explain the that folder, creates the ter base command
@echo off
:: Check if the script is running with administrator privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo This script requires administrator privileges. Attempting to run as administrator...
    powershell -Command "Start-Process '%~f0' -Verb runAs"
    exit /b
)

:: Set variables
SET "COMMAND_FOLDER=C:\term"
SET "CONTEXT_FILE=context.txt"
SET "FILE_CONTENT=This folder contains all scripts added by term!"
SET "COMMAND_TERM=term"
SET "COMMAND_TERM_FILE=%COMMAND_FOLDER%\%COMMAND_TERM%.bat"

:: Verifies if folder already exists
if not exist "%COMMAND_FOLDER%" (
    echo Creating %COMMAND_FOLDER% folder...
    mkdir "%COMMAND_FOLDER%"
    echo Folder created successfully.
) else (
    echo %COMMAND_FOLDER% folder already exists.
)

REM Verifica se o ficheiro já existe
if not exist "%COMMAND_FOLDER%\%CONTEXT_FILE%" (
    echo Creating %CONTEXT_FILE% file...
    echo %FILE_CONTENT% > "%COMMAND_FOLDER%\%CONTEXT_FILE%"
    echo File %COMMAND_FOLDER% created with success.
) else (
    echo File %CONTEXT_FILE% already exists in %COMMAND_FOLDER%.
)

REM Create the term.bat file if it doesn't exist
if not exist "%COMMAND_TERM_FILE%" (
    echo Creating %COMMAND_TERM_FILE%...
    (
        echo @echo off
        echo echo Hello from command file!
    ) > "%COMMAND_TERM_FILE%"
    echo Command file created successfully.
) else (
    echo %COMMAND_TERM_FILE% already exists.
)

set "SOURCE_SCRIPT=%~dp0%COMMAND_TERM%.bat"
set "DESTINATION_SCRIPT=%MAIN_DIR%\%COMMAND_TERM%"

if exist "%SOURCE_SCRIPT%" (
    copy "%SOURCE_SCRIPT%" "%DESTINATION_SCRIPT%"
    echo Copied term.bat to %DESTINATION_SCRIPT%.
) else (
    echo Source script %SOURCE_SCRIPT% not found. Cannot copy.
)

REM Check if the path length exceeds 1024 characters
FOR /F "tokens=*" %%A IN ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v Path') DO (
    SET "FULL_PATH=%%A"
)

IF "%FULL_PATH:~1024%" NEQ "" (
    echo Warning: The Path variable is longer than 1024 characters and will not be modified.
    echo You may need to manually add %COMMAND_DIR% to the system Path.
    pause
    exit /b
)

REM Add the directory to the system Path
SET "CURRENT_PATH=%PATH%"
echo %CURRENT_PATH% | find /i "%COMMAND_DIR%" >nul
if %ERRORLEVEL%==0 (
    echo The directory %COMMAND_DIR% is already in the Path.
) else (
    echo Adding %COMMAND_DIR% to the Path...
    setx PATH "%PATH%;%COMMAND_DIR%" /M
    echo Directory added successfully to the system Path.
)

pause