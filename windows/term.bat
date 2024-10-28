@echo off
:: Global variables
SET argC=0
SET iteration=0
set "MAIN_DIR=C:\term"

:: Check if parameters are provided
if "%~1"=="" (
    echo No parameters have been provided.
    echo Usage: term script_name command or use "term help"
    exit /b 1
)

:: Check if the command is 'help'
if /i "%~1"=="help" (
    echo.
echo Available commands:
echo   term help                          : Show help message.
echo   term list                          : Show all terms.
echo   term show term_name                : Show the script of a specific term.
echo   term delete [or -D] term_name      : Delete a term user previously added.
echo   term term_name command             : Create a new term.
echo.
exit /b 0
)

:: Check if the command is 'show'
if /i "%~1"=="show" (
    if "%~2"=="" (
        echo No script name provided for display.
        echo Usage: term show script_name or use "term help"
        exit /b 1
    )

    if exist "%MAIN_DIR%\%~2.bat" (
        echo Displaying the content of %~2.bat:
        type "%MAIN_DIR%\%~2.bat"
    ) else (
        echo Script %~2.bat does not exist in %MAIN_DIR%.
    )
    
    exit /b 0
)

:: Check if the command is 'list'
if /i "%~1"=="list" (
    echo List of all terms:
    dir /b "%MAIN_DIR%\*.bat"
    exit /b 0
)

:: Check if the command is 'delete' or '-D'
if /i "%~1"=="delete" (
    set "SCRIPT_NAME=%~2"
) else if /i "%~1"=="-D" (
    set "SCRIPT_NAME=%~2"
) else (
    set "SCRIPT_NAME="
)

:: If the script name is provided for deletion, need to improve this code
if defined SCRIPT_NAME (
    if "%SCRIPT_NAME%"=="" (
        echo No script name provided for deletion.
        echo Usage: term delete script_name OR term -D script_name
        exit /b 1
    )

    set "SCRIPT_TO_DELETE=%MAIN_DIR%\%SCRIPT_NAME%.bat"

    ::echo "%SCRIPT_TO_DELETE%"
    ::echo %MAIN_DIR%\%SCRIPT_NAME%.bat

    if exist "%MAIN_DIR%\%SCRIPT_NAME%.bat" (
        del "%MAIN_DIR%\%SCRIPT_NAME%.bat"
        echo Script %SCRIPT_NAME%.bat deleted successfully from %MAIN_DIR%.
    ) else (
        echo Script %SCRIPT_NAME%.bat does not exist in %MAIN_DIR%.
    )
    exit /b 0
)

:: Count how many args are in the command
for %%x in (%*) do Set /A argC+=1

:: Set the arguments into vars
SET COMMAND_NAME=%~1
SET "COMMAND="

:: If is less than 2, drop error, that needs to give another argument
if %argC% lss 2 (
    echo No script to add to the command
    ECHO Use "term help"
    exit /b 1
)

:: Check if user used double quote or not
if %argC% gtr 2 (
    
    echo %iteration%
    pause
    :: User didnt use double quote, so command is from argument 1 until the last
    for %%i in (%*) do (
        Set /A iteration+=1
        echo Iteration: !iteration! - Argument: %%i

    if %iteration% gtr 1 (
        echo asdadsadasdasdasd
        SET "COMMAND=%COMMAND% %%i"
    )
    )
) else (
    :: User used double quote, command is inside double quote
    SET "COMMAND=%~2"
)

echo Script Name: %COMMAND_NAME%
echo Command: %COMMAND%

:: Verify if C:\term exists
if not exist "%MAIN_DIR%" (
    echo Folder doesnt exist
    exit /b 1
)

::Create the var to the path of the file
set "SCRIPT_FILE=%MAIN_DIR%\%COMMAND_NAME%.bat"

if exist %SCRIPT_FILE% (
    echo A script with that name already exists. Name of the script: %COMMAND_NAME%
    exit /b 1
) 

:: Insert the code into the file
(
    echo @echo off
    echo %COMMAND%
) > "%SCRIPT_FILE%"

:: Final words
echo Script %COMMAND_NAME%.bat successfully created in %SCRIPT_FILE%.
echo You can now use the term %COMMAND_NAME%.