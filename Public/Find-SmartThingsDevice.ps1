function Find-SmartThingsDevice {
    <#
    .SYNOPSIS
        Searches your smartthings devices, supports various parameters as filters
    .PARAMETER Name
        Device Label from smartthings, supports wildcards
    
    .PARAMETER deviceTypeName
        deviceTypeName as configured in SmartThings
    
    .PARAMETER capability
        capability as configured in SmartThings


    .EXAMPLE
        Find-SmartThingsDevice -name "kitchen" -capability "switch"
    
    .EXAMPLE
        Find-SmartThingsDevice -deviceTypeName "Z-Wave Switch"
    
    .EXAMPLE
        Find-SmartThingsDevice -capability "switch","powerMeter"
    

    #>
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param (
        #[Parameter(Mandatory = $false,
        #ParameterSetName="name")]
        [string]$Name,

        #[Parameter(Mandatory = $false,
        #ParameterSetName="deviceTypeName")]
        [string]$deviceTypeName,

        #[Parameter(Mandatory = $false)]
        [string[]]$capability
        #capabilities are case sensative and usually camelCase
    )
    begin {
        Write-Verbose "[$(Get-Date)] Begin :: $($MyInvocation.MyCommand)"
        if ($capability) {
            #Build URL String query
            $Parameters = [System.Web.HttpUtility]::ParseQueryString([String]::Empty)

            foreach ($item in $capability) {
                $Parameters.Add('capability', $item)
            }
            $Request = [System.UriBuilder]"$STAPI/devices"
            $Request.Query = $Parameters.ToString()

            $URL = $Request.Uri
        }
        else {
            $URL = "$STAPI/devices"
        }
    }
    process {
        $Devices = (Send-SmartthingsAPI -URL $URL).items
        if ($name) {
            $Devices = $Devices | Where-Object { $_.label -like "*$name*" }
            $Devices
            
        }
        elseif ($deviceTypeName) {
            $Devices = $Devices.items | Where-Object { $_.deviceTypeName -like "*$deviceTypeName*" }
            $Devices
        }
        else { $Devices}
    }
    end {
        Write-Verbose "Found $($Devices | Measure-Object | Select-Object -ExpandProperty count) device(s)"
        Write-Verbose "[$(Get-Date)] End :: $($MyInvocation.MyCommand)"
    }
}