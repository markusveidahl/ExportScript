# ExportScript

```diff
==============================================                                        
           Get-WindowsAutoPilotInfo                           
==============================================                                                  
[+] Creating the Outputfile..                                                                                           
[+] Getting AutoPilotInfo                                                                                               
[+] Adding AutoPilotInfo to output file                                                                                 
[+] Cleaning up..                                                                                                     
[+] Done! 
```



### Export Windows AutoPilot Info for multiple devices

```
1. Configure "Scripts\Export.ps1" with the preferred group tag

2. Add the files to an empty USB-Stick

3. Open cmd on the device you want to import.

4. Navigate to the USB using cmd (Ex: **cd D:**)

5. Run the "Export" script by doing: .\Export

6. The AutoPilotInfo will be added to a CSV file in the "Import" folder

7. Repeat for the next machine

8. Once done, go to the Intune AutoPilot panel and click "import", then select the CSV file in the "Import" folder.
```

This script uses some code from "Get-WindowsAutoPilotInfo.ps1" by Michael Niehaus (https://www.powershellgallery.com/packages/Get-WindowsAutoPilotInfo/1.6)

