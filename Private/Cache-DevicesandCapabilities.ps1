function Cache-DevicesandCapabilities {

    <#
    .Description
    Caches all devices and capabilites for use elsewhere in the script
    #>

    param(
        [switch]$refresh
    )

    begin {
        Write-Verbose "[$(Get-Date)] Begin :: $($MyInvocation.MyCommand)"
    }

    process {
        $DevicesAndCapabilities = Find-SmartThingsDevice | Select-Object  label, @{label = "Capability"; Expression = {$_.components.capabilities.id}}
        $Script:DevicesAndCapabilities
    }

    end {
        Write-Verbose "[$(Get-Date)] End :: $($MyInvocation.MyCommand)"
    }
}