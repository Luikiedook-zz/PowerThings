#-----------------------------------------------------------------------------------------------------------------------
#region Load Functions
#-----------------------------------------------------------------------------------------------------------------------
Get-ChildItem $PSScriptRoot\Private | Foreach-Object {. $_.FullName}
Get-ChildItem $PSScriptRoot\Public  | Foreach-Object {. $_.FullName}
#endregion Load Functions
#-----------------------------------------------------------------------------------------------------------------------



#array of hash tables of global variables we want to set in this module
$GlobalsToSet = @(
    #Base URL for API
    @{
        VarName  = "STAPI"
        VarValue = "https://api.smartthings.com/v1"
    }
)

#iterate through each variable and earn if already present, else set them
$GlobalVars = Get-Variable -Scope Global
ForEach ($Var in $GlobalsToSet) {
    if ($GlobalVars | where-object {$_.Name -eq $($Var["VarName"])}) {
        #warn if already present
        Write-verbose "$($Var["VarName"]) is already present"
    }
    else {
        #set the constant variable
        $Params = @{
            Name   = "$($Var["VarName"])"
            Value  = "$($Var["VarValue"])"
            Option = 'ReadOnly'
            Scope  = 'Global'
        }
        New-Variable @Params
    }
}

#Cache devices and capabilities
Write-Host "Attempting to cache Capabilities and devices `$SmartThingsToken token will be required"
Get-DevicesandCapabilitiesCache
#Dot source the files
