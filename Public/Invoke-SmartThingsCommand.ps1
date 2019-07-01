function Invoke-SmartThingsCommand
{
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
        [parameter(Mandatory=$True, ValueFromPipeline)]
        $Device,
        $command,
        $capability
    )
    

    begin {
        $commandStructure = "[{command: '$command', capability: '$capability'}]"
        Write-Verbose -Message $commandStructure
        Write-Verbose -Message "Device: $device.label"
        Write-Verbose -Message "Capability: $capability "
        
    }

    process {
        foreach($item in $Device)
        {
            Send-SmartThingsAPI -URL "$STAPI/devices/$($item.deviceId)/commands" -Body $commandStructure -Method POST
        }
    }

    end {

    }

    
    
}