# PowerThings

Powershell module for SmartThings

### Prerequisites

Powershell version 3 or later and a Smartthings Personal access token that has adequate permissions

https://account.smartthings.com/tokens

### References
https://smartthings.developer.samsung.com/docs/api-ref/st-api.html


# Examples

Supports tab completion of your devices and capabilities
```powershell
Set-SmartThingsDevice -Device 'Dining Room Light' -Capability switch -command on
```

```powershell
Find-SmartThingsDevice | select-object label
```

```powershell
Find-SmartThingsDevice -name "office" | Invoke-SmartThingsCommand -command on -capability switch
```
 


### Installing

```powershell
Import-Module .\PowerThings.psm1
```
or copy to Powershell Module path "C:\Program Files\WindowsPowerShell\Modules" in Powershell version 4 and up



## Built With

VSCode

## Contributing

Pull Requests welcome


## Authors

* **John Luikart** - *Initial work* - [Luikiedook](https://github.com/Luikiedook)


## Acknowledgments

* [FoxDeploy](https://foxdeploy.com/2017/01/13/adding-tab-completion-to-your-powershell-functions/)
* [Joeypiccola](https://gist.github.com/joeypiccola/75cd1f4fd5c2e5f429d7dc580ce6b420)
for helping me figure out dynamic functions
