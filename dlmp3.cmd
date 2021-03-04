@ECHO OFF
SETLOCAL EnableDelayedExpansion

REM directory to save downloads in (directory must already be created)
SET saveDirectory=%USERPROFILE%\desktop\dlmp3_files

REM url to the youtube video
SET url=%1

REM name to save the file as
SET fileName=%2

REM Time to begin downloading from, in HH:MM:SS format.
SET begin=%3

SET end=%4

REM Prompt for input if no parameters were passed in.
IF [%1]==[] (
  SET /P url="Link to youtube video: "
  SET /P fileName="Name of output file (without extension): " 
  SET /P begin="Timestamp to start converting (HH:MM:SS): (00:00:00) "
  SET /P end="Timestamp to stop converting (optional): "
)

if [%begin%]==[] (
  SET begin=0
) ELSE (
  REM First, check that the 'begin' variable is 8 characters long.
  CALL :strlen length begin  
  IF !length! NEQ 8 GOTO formatError

  REM Extract the starting time from the input. Format should be in HH:MM:SS.  
  SET hours=%begin:~0,2%
  SET minutes=%begin:~3,2%
  SET seconds=%begin:~6,2%
  SET /a begin=(!hours!*60*60^)+(!minutes!*60^)+!seconds!
)

if [%end%]==[] (

  ytdl %url:"=% | ffmpeg -ss %begin% -i pipe:0 -b:a 192K -vn %saveDirectory%\%fileName:"=%.mp3

) ELSE (
  REM Perform same checks for 'end' variable as with 'begin' variable
  CALL :strlen length end  
  IF !length! NEQ 8 GOTO formatError

  REM Extract the starting time from the input. Format should be in HH:MM:SS.  
  SET hours=%begin:~0,2%
  SET minutes=%begin:~3,2%
  SET seconds=%begin:~6,2%
  SET /a begin=(!hours!*60*60^)+(!minutes!*60^)+!seconds!

  ytdl %url:"=% | ffmpeg -ss %begin% -to %end% -i pipe:0 -b:a 192K -vn %saveDirectory%\%fileName:"=%.mp3
)



ENDLOCAL

EXIT /B 0

:formatError
(
  ECHO Error: The duration should be in HH:MM:SS format.
)

:strlen <resultVar> <stringVar>
(   
    setlocal EnableDelayedExpansion
    set "s=!%~2!#"
    set "len=0"
    for %%P in (4096 2048 1024 512 256 128 64 32 16 8 4 2 1) do (
        if "!s:~%%P,1!" NEQ "" ( 
            set /a "len+=%%P"
            set "s=!s:~%%P!"
        )
    )
)
( 
    endlocal
    set "%~1=%len%"
    exit /b
)