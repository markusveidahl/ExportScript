# Just printing the cool header
Write-Output "=============================================="
Write-Host   "          Get-WindowsAutoPilotInfo" -ForegroundColor 2
Write-Output "=============================================="

# Setting the GroupTag, change this!
$GroupTag = "GroupTag"

# Path to the output file
$OutputFilePath = "Import\Output.csv"

# Creating the output file 
if(-Not (Test-Path $OutputFilePath)){
    Write-Host "[+] Creating the Outputfile.."
    Add-Content $OutputFilePath -Value "Device Serial Number,Windows Product ID,Hardware Hash,Group Tag"
}

# Creating a temporary file for later use
Write-Host "[+] Getting AutoPilotInfo"
powershell.exe '.\Scripts\Get-WindowsAutoPilotInfo.ps1 -OutputFile Temporary.csv'

# Adding the group-tag and appending to the output file
Get-Content -Path "Temporary.csv" | Select-Object -Skip 1 | ForEach-Object {
    Write-Host "[+] Adding AutoPilotInfo to output file"
    $line = "$_,Elev"
    Add-Content -Path $OutputFilePath -Value "$line"
}

# Cleaning up
if(Test-Path -Path Temporary.csv){
    Write-Host "[+] Cleaning up.."
    Remove-Item -Path Temporary.csv
}

# Creating a handy log file
$SN = (Get-WmiObject win32_bios).SerialNumber
Add-Content -Path Import\Log.txt -Value "$SN"

# Done!
Write-Host "Done!" -ForegroundColor 2