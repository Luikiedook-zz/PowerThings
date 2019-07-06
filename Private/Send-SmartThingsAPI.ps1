Function Send-SmartThingsAPI {
    <#
    .SYNOPSIS
        Send something to the Smarthings API

    .DESCRIPTION
        Main function used to call Smarthings API
        https://smartthings.developer.samsung.com/docs/api-ref/st-api.html

    .PARAMETER Method
        Smarthings API method to call.

    .PARAMETER URL
        full URL of the rest call.

    .PARAMETER Body
        Body of the  Smarthings API call.

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

        # Open to suggestions or pull requests on better ways to do this.
        if (-not $SmartThingsToken) {
            do {
                try {
                    [guid]$Global:SmartThingsToken = Read-Host -Prompt "Smartthings Token no present please enter it here or save to `$SmartThingsToken"
                }
                catch {Write-Host "Invalid Smartthings Token" -ForegroundColor Red}
            } until ($SmartThingsToken)
        }

        $Params = @{
            Headers     = @{
                "Authorization" = "Bearer $SmartThingsToken"
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
        try {
            $Response = Invoke-RestMethod @Params
        }
        catch {
            $Message = $_.ErrorDetails.Message;
            Write-Host "$($Message | convertfrom-json | convertto-json -depth 100)" -ForegroundColor Red
        }

        if (-not [string]::IsNullOrEmpty($Response))
        {
            $Response
        }

    }
    end {
        Write-Verbose "[$(Get-Date)] End :: $($MyInvocation.MyCommand)"
    }
}
