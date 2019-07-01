function Set-SmartThingsDevice{
    <#
    .SYNOPSIS
        Allows controlling of smarthings devices with dynamic tab completion of device labels and capabilities

    .DESCRIPTION
        Allows control of smart things devices, device list and capabilities are built dynamically from your devices

    .PARAMETER Device
        Smarthings Label of Device

    .PARAMETER Capability
        

    #>
    [CmdletBinding()]
    param()
    DynamicParam{
        $attributes = new-object System.Management.Automation.ParameterAttribute
        $attributes.Mandatory = $false

        $attributeCollection = new-object -Type System.Collections.ObjectModel.Collection[System.Attribute]
        $attributeCollection.Add($attributes)

        $paramDictionary = new-object -Type System.Management.Automation.RuntimeDefinedParameterDictionary
        #Start Device Name
        $DeviceLabelArray = (Find-SmartThingsDevice).label
        $DeviceLabelValidSet = New-Object System.Management.Automation.ValidateSetAttribute($DeviceLabelArray)
        $AttributeCollection.Add($DeviceLabelValidSet)

        $dynParam1 = new-object -Type System.Management.Automation.RuntimeDefinedParameter("Device", [string], $attributeCollection)
            
        
        $paramDictionary.Add("Device", $dynParam1)
        #End Device Name

        #Start Device Capability
        $deviceCapabilityArray = (Find-SmartThingsDevice -name $dynParam1).components.capabilities.id
        $DeviceCapabilityValidSet = New-Object System.Management.Automation.ValidateSetAttribute($deviceCapabilityArray)
        $AttributeCollection.Add($DeviceCapabilityValidSet)

        $dynParam2 = new-object -Type System.Management.Automation.RuntimeDefinedParameter("Capability", [string], $attributeCollection)
        $paramDictionary.Add("Capability", $dynParam2)
        #End Device Capability

        return $paramDictionary
    }

}