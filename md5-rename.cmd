@ECHO off
REM Batch script but relies on powershell under the hood.
REM Currently only works on files with extension.

REM Assign file path to a variable
SET filepath=%1

REM Check that the file path has been provided, if not exit
IF [%1]==[] (
    echo Provide a file path to calculate MD5 hash of.
    exit
)

REM Check that the file exists, if not exit
IF NOT EXIST %filepath% (
    echo Specified file does not exist.
    exit
)

REM Single-liner powershell commands delimited by semicolons.
REM First assigns the $ext variable to hold the extension of the original file name.
REM Trims off trailing .\ and ./ then split by dot.
REM If length of the resulting array is greater than 1, there is an extension.
REM Take the final item in the array as the extension.
REM Next, calculate the hash by using Get-FileHash command.
REM Finally, rename the file based on the file hash and the extracted file extension.
REM If there is no file extension, the resulting file name will have no extension.

powershell -C $ext=if(('%filepath%'.Trim('.\').Trim('.\').Split('.')).Length -gt 1) {('%filepath%'.Split('.'))[-1]} else {''};$hash="(Get-FileHash '%filepath%' -Algorithm md5).Hash.ToLower()";Rename-Item -Path '%filepath%' -NewName "${hash}`.${ext};