function Invoke-SmartThingsCommand {
    <#
    .SYNOPSIS
        execute a command in smartthings

    .DESCRIPTION
        Function used for executing commands on smartthings devices, such as turning on or off a light
        https://smartthings.developer.samsung.com/docs/api-ref/st-api.html

    .PARAMETER Device
        Device(s) to run the command on

    .PARAMETER Command
        Command to Run

    .PARAMETER Example
        Find-SmartThingsDevice -name "office" -capability "switch" | Invoke-SmartThingsCommand -command off -capability switch
    #>
    [CmdletBinding()]
    param(
        [parameter(Mandatory)]
        $Device,
        [parameter(Mandatory)]
        $command,
        [parameter(Mandatory)]
        $capability
    )
    

    begin {
        Write-Verbose "[$(Get-Date)] Begin :: $($MyInvocation.MyCommand)"
        $commandStructure = "[{command: '$command', capability: '$capability'}]"
        
    }

    process {
        foreach ($item in $Device) {
            
            Send-SmartThingsAPI -URL "$STAPI/devices/$($item.deviceId)/commands" -Body $commandStructure -Method POST

            Write-Verbose -Message "Device: $($item.label) Command: $command Capability $($item.label)"
        }
    }

    end {
        Write-Verbose "[$(Get-Date)] End :: $($MyInvocation.MyCommand)"
    }
}