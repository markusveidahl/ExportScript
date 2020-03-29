[CmdletBinding()]
param(
    [Parameter(Mandatory=$False,ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$True,Position=0)][alias("DNSHostName","ComputerName","Computer")] [String[]] $Name = @("localhost"),
    [Parameter(Mandatory=$False)] [String] $OutputFile = "", 
    [Parameter(Mandatory=$False)] [Switch] $Append = $false,
    [Parameter(Mandatory=$False)] [System.Management.Automation.PSCredential] $Credential = $null,
    [Parameter(Mandatory=$False)] [Switch] $Partner = $false,
    [Parameter(Mandatory=$False)] [Switch] $Force = $false
)

Begin
{
    # Initialize empty list
    $computers = @()
}

Process
{
    foreach ($comp in $Name)
    {
        $bad = $false

        # Get a CIM session
        if ($comp -eq "localhost") {
            $session = New-CimSession
        }
        else
        {
            $session = New-CimSession -ComputerName $comp -Credential $Credential
        }

        # Get the common properties.
        Write-Verbose "Checking $comp"
        $serial = (Get-CimInstance -CimSession $session -Class Win32_BIOS).SerialNumber

        # Get the hash (if available)
        $devDetail = (Get-CimInstance -CimSession $session -Namespace root/cimv2/mdm/dmmap -Class MDM_DevDetail_Ext01 -Filter "InstanceID='Ext' AND ParentID='./DevDetail'")
        if ($devDetail -and (-not $Force))
        {
            $hash = $devDetail.DeviceHardwareData
        }
        else
        {
            $bad = $true
            $hash = ""
        }

        # If the hash isn't available, get the make and model
        if ($bad -or $Force)
        {
            $cs = Get-CimInstance -CimSession $session -Class Win32_ComputerSystem
            $make = $cs.Manufacturer.Trim()
            $model = $cs.Model.Trim()
            if ($Partner)
            {
                $bad = $false
            }
        }
        else
        {
            $make = ""
            $model = ""
        }

        # Getting the PKID is generally problematic for anyone other than OEMs, so let's skip it here
        $product = ""

        # Depending on the format requested, create the necessary object
        if ($Partner)
        {
            # Create a pipeline object
            $c = New-Object psobject -Property @{
                "Device Serial Number" = $serial
                "Windows Product ID" = $product
                "Hardware Hash" = $hash
                "Manufacturer name" = $make
                "Device model" = $model
            }
            # From spec:
            # "Manufacturer Name" = $make
            # "Device Name" = $model

        }
        else
        {
            # Create a pipeline object
            $c = New-Object psobject -Property @{
                "Device Serial Number" = $serial
                "Windows Product ID" = $product
                "Hardware Hash" = $hash
            }
        }

        # Write the object to the pipeline or array
        if ($bad)
        {
            # Report an error when the hash isn't available
            Write-Error -Message "Unable to retrieve device hardware data (hash) from computer $comp" -Category DeviceError
        }
        elseif ($OutputFile -eq "")
        {
            $c
        }
        else
        {
            $computers += $c
        }

        Remove-CimSession $session
    }
}

End
{
    if ($OutputFile -ne "")
    {
        if ($Append)
        {
            if (Test-Path $OutputFile)
            {
                $computers += Import-CSV -Path $OutputFile
            }
        }
        if ($Partner)
        {
            $computers | Select "Device Serial Number", "Windows Product ID", "Hardware Hash", "Manufacturer name", "Device model" | ConvertTo-CSV -NoTypeInformation | % {$_ -replace '"',''} | Out-File $OutputFile
            # From spec:
            # $computers | Select "Device Serial Number", "Windows Product ID", "Hardware Hash", "Manufacturer Name", "Device Name" | ConvertTo-CSV -NoTypeInformation | % {$_ -replace '"',''} | Out-File $OutputFile
        }
        else
        {
            $computers | Select "Device Serial Number", "Windows Product ID", "Hardware Hash" | ConvertTo-CSV -NoTypeInformation | % {$_ -replace '"',''} | Out-File $OutputFile
        }
    }
}