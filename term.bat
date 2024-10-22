@echo off
:: Global variables
SET argC=0
SET iteration=0
set "MAIN_DIR=C:\term"

:: Check if parameters are provided
if "%~1"=="" (
    echo No parameters have been provided.
    echo Usage: term script_name command
    exit /b 1
)

:: Count how many args are in the command
for %%x in (%*) do Set /A argC+=1

:: Set the arguments into vars
SET COMMAND_NAME=%~1
SET "COMMAND="
::Remove the first parameter from the arguments of the command to execute


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