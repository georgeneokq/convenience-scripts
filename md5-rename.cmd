@ECHO off
REM Batch script but relies on powershell under the hood.
REM Currently only works on files with extension.

REM Check that the file path has been provided, if not exit
IF [%1]==[] (
    echo Provide a file path to calculate MD5 hash of.
    exit
)

REM Check that the file exists, if not exit
IF NOT EXIST %1 (
    echo Specified file does not exist.
    exit
)

REM Single-liner powershell commands delimited by semicolons.
REM As time taken for hash calculation may be noticable when file is large,
REM print a message to assure the user that the hash is being calculated.
REM Spaces are treated as newline when running powershell as a cmd command,
REM so print only one word to avoid weird output (workaround)
REM Then, assign the $ext variable to hold the extension of the original file name.
REM Trims off trailing .\ and ./ then split by dot.
REM If length of the resulting array is greater than 1, there is an extension.
REM Take the final item in the array as the extension.
REM Next, calculate the hash by using Get-FileHash command.
REM Finally, rename the file based on the file hash and the extracted file extension.
REM If there is no file extension, the resulting file name will have no extension.

REM The following command can be copy-pasted without modification into the registry
REM to create a convenient context menu option to rename a file using its hash.
REM Path: Computer\HKEY_CLASSES_ROOT\*\shell\md5-rename\command
REM Paste the command below into its default value.
powershell -C echo "Processing...";$ext=if(('%1'.Trim('.\').Trim('.\').Split('.')).Length -gt 1) {('%1'.Split('.'))[-1]} else {''};$hash="(Get-FileHash '%1' -Algorithm md5).Hash.ToLower()";Rename-Item -Path '%1' -NewName "${hash}`.${ext};