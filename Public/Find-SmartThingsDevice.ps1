function Find-SmartThingsDevice {
    <#
    
    .EXAMPLE
        Find-Device -name "kitchen" -capability "switch"
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
        if ($capability) {
            #Build URL String query
            $Parameters = [System.Web.HttpUtility]::ParseQueryString([String]::Empty)

            foreach ($item in $capability) {
                $Parameters.Add('capability', $item)
            }
            $Request = [System.UriBuilder]"$STAPI/devices"
            $Request.Query = $Parameters.ToString()
            $Request.Uri

            $URL = $Request.Uri
        }
        else {
            $URL = "$STAPI/devices"
        }
    }
    process {
        $Devices = Send-SmartthingsAPI -URL $URL
        if ($name) {
            return $Devices.items | Where-Object {$_.label -like "*$name*"}
        }
        if ($Type) {
            return $Devices.items | Where-Object {$_.deviceTypeName -like "*$type*"}
        }
        return $Devices.items
    }
    end {
        Write-Verbose "Found $($Devices.items.Count) devices"
    }
}