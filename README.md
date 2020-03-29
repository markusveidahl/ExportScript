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



### Export AutoPilotInfo for multiple devices in seconds using this automatic script.

```
1. Configure "Scripts\Export.ps1" with the preferred Group-tag

2. Add the files to an empty USB-Stick

3. Open cmd on the device you want to import.

4. Run the Export-script using the following command: .\Export

5. The AutoPilotInfo will be added to a CSV file in the "Import" folder

6. Repeat for the next machine

7. Once done, go to the Intune AutoPilot panel and click "import", then select the CSV file in the "Import" folder.
```
The script is written in a way to bypass any potential errors, let's hope it works for you as well.

This script uses "Get-WindowsAutoPilotInfo.ps1" by Michael Niehaus (https://www.powershellgallery.com/packages/Get-WindowsAutoPilotInfo/1.6)

