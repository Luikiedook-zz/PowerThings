Function Send-SmartThingsAPI {
    <#
    .SYNOPSIS
        Send something to the Smarthings API

    .DESCRIPTION
        Main function used to call Smarthings API
        https://smartthings.developer.samsung.com/docs/api-ref/st-api.html

    .PARAMETER Method
        Smarthings API method to call.

    .PARAMETER Body
        Arguments to send to the Smarthings API.

    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [String]$URL,

        [ValidateSet("GET", "POST", "PUT", "DELETE")]
        [Parameter(Mandatory = $false)]
        [String]$Method = "Get",

        [Parameter(Mandatory = $false)]
        [string]$Body,

        $URLParameters
    )
    begin {
        Write-Verbose "[$(Get-Date)] Begin :: $($MyInvocation.MyCommand)"

        if (-not $SmartthingsToken)
        {
            $Global:SmartthingsToken = Read-Host -Prompt "Smartthings Token no present please enter it here: "
        }

        $Params = @{
            Headers     = @{
                "Authorization" = "Bearer $SmartthingsToken"
                "Accept"        = "application/json"
            }
            Uri         = $URL
            Method      = $Method
            ContentType = "application/json"
            ErrorAction = "Stop"
        }

        # Add our body if using put or post
        If (("Post", "PUT", "DELETE" -contains $Method)) {
            if (-NOT $Body) {
                Throw "ERROR: No -Body supplied with put or post method"
            }
            else {
                $Params.Add("Body", $Body)
            }
        }
    }
    process {
        $Response = Invoke-RestMethod @Params
        if ($Response) {$Response}
    }
    end {
        Write-Verbose "[$(Get-Date)] End :: $($MyInvocation.MyCommand)"
    }
}
