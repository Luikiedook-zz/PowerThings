function Set-SmartThingsDevice {
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
    param($command)
    DynamicParam {
        #Region Device
        # Set the dynamic parameters' name
        $ParamName_Device = 'Device'

        # Create the collection of attributes
        $attributeCollection = new-object -Type System.Collections.ObjectModel.Collection[System.Attribute]

        # Create and set the parameters' attributes
        $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
        $ParameterAttribute.Mandatory = $true
        $ParameterAttribute.Position = 1

        # Add the attributes to the attributes collection
        $AttributeCollection.Add($ParameterAttribute)

        # Create the dictionary 
        $RuntimeParameterDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary

        # Generate and set the ValidateSet 
        $arrSet = if ($DevicesAndCapabilities) {
            $DevicesAndCapabilities.label
        }
        else {
            (Find-SmartThingsDevice).label
        }
        $ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($arrSet)

        # Add the ValidateSet to the attributes collection
        $AttributeCollection.Add($ValidateSetAttribute)
        # Create and return the dynamic parameter
        $RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($ParamName_Device, [string], $AttributeCollection)
        $RuntimeParameterDictionary.Add($ParamName_Device, $RuntimeParameter)
        #endregion Device

        #Region Capability
        $ParamName_Capability = 'Capability'
        # Create the collection of attributes
        $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
        # Create and set the parameters' attributes
        $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
        $ParameterAttribute.Mandatory = $true
        $ParameterAttribute.Position = 2
        # Add the attributes to the attributes collection
        $AttributeCollection.Add($ParameterAttribute)  
        # Generate and set the ValidateSet 
        $arrSet = if ($DevicesAndCapabilities)
        {
            $DevicesAndCapabilities.capability | Sort-Object | Get-Unique
        }
        else {
            (Find-SmartThingsDevice).components.capabilities.id | Sort-Object | Get-Unique
        }
        $ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($arrSet)
        $ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($arrSet)
        # Add the ValidateSet to the attributes collection
        $AttributeCollection.Add($ValidateSetAttribute)
        # Create and return the dynamic parameter
        $RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($ParamName_Capability, [string], $AttributeCollection)
        $RuntimeParameterDictionary.Add($ParamName_Capability, $RuntimeParameter)
        #endregion Capability
        
        return $RuntimeParameterDictionary
    }
    begin{
        Write-Verbose "[$(Get-Date)] Begin :: $($MyInvocation.MyCommand)"
        $deviceLabel = $PSBoundParameters[$ParamName_Device]
        $capability = $PSBoundParameters[$ParamName_Capability]
    }
    process {
        $Device = Find-SmartThingsDevice -name $deviceLabel

        Invoke-SmartThingsCommand -Device $Device -command $command -capability $capability
    }
    end{
        Write-Verbose "[$(Get-Date)] End :: $($MyInvocation.MyCommand)"
    }
        
}