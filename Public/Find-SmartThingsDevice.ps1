function Find-SmartThingsDevice {
    <#
    
    .EXAMPLE
        Find-SmartThingsDevice -name "kitchen" -capability "switch"
    
    .EXAMPLE
        Find-SmartThingsDevice -deviceTypeName "Z-Wave Switch"
    

    #>
    [CmdletBinding()]
    param (
        #[Parameter(Mandatory = $false,
        #ParameterSetName="name")]
        [string]$name,

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
        Write-Verbose "Found $($Devices | measure-object | Select-Object -expandproperty count) device(s)"
        Write-Verbose "[$(Get-Date)] End :: $($MyInvocation.MyCommand)"
    }
}