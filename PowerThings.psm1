#-----------------------------------------------------------------------------------------------------------------------
#region Load Functions
#-----------------------------------------------------------------------------------------------------------------------
Get-ChildItem $PSScriptRoot\Private | Foreach-Object {. $_.FullName}
Get-ChildItem $PSScriptRoot\Public  | Foreach-Object {. $_.FullName}
#endregion Load Functions
#-----------------------------------------------------------------------------------------------------------------------

$Global:STAPI = 'https://api.smartthings.com/v1'


#array of hash tables of global variables we want to set in this module
$GlobalsToSet = @(
    #Base URL for API
    @{
        VarName  = "STAPI"
        VarValue = "https://api.smartthings.com/v1"
    }
)

#iterate through each variable and earn if already present, else set them
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
        New-Variable  @Params
    }
}
#Dot source the files
