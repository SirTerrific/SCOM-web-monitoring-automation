# SCOM-web-monitoring-automation
This tool can be used to generate and import Web Application Availability Monitor automatically to SCOM.

Idea here is that application should contain some text based self diagnostics monitoring page (example "monitoring.aspx") what SCOM will call.
That page should call application web services and do all other needed task to make sure that everything is OK on application side.
Only if all checks was done successfully application print text "SUCCESSFULLY" and it some task takes too long time it can also write text "SLOWEXISTS".

SCOM is looking for that "SUCCESSFULLY" and it raises critical alert if it is missing and warning if there is "SLOWEXISTS" text.

Here is example for content what page would show:
```
ExampleService1  OK|10
ExampleService2  OK|500
ExampleService3  OK|30
SUCCESSFULLY
SLOWEXISTS
```
Where all services was running but second one took too long time (500ms) to respond so there is also "SLOWEXISTS" text.


## Files
| File                                     | Description                                         |
|------------------------------------------|-----------------------------------------------------|
| GenerateManagementPackForURLmonitors.ps1 | Generates management pack based on parameters       |
| example.ps1                              | Example script                                      |
| lastversion.txt                          | Source file for version number. Used by example.ps1 |

# Using example.ps1
To be able to use example.ps1 you need fill following parameters to it:
* $managementActionPointId
* $MonitorUniqueIdentifier
* $FolderItemID1
* $FolderItemID2


$managementActionPointId -value must be ID for server which is used to testing for these urls.
You can find it using these commands:
```PowerShell
$ServerFQDN = "server.domain.local"
$SCOMClassInstaces = Get-SCOMClassInstance
$managementActionPointServer = $SCOMClassInstaces | Where-Object {($_.MonitoringClassIds  -eq "d95d497c-25ec-9213-200c-50506912dad3") -and ($_.DisplayName -eq $ServerFQDN)}
$managementActionPointServer.id.Guid
```

To $MonitorUniqueIdentifier, $FolderItemID1 and $FolderItemID2 you need fill unique id.
SCOM uses unique IDs on GUID format without hyphen (-). You can generate these using this command:
```PowerShell
([guid]::NewGuid()).Guid -replace "-",""
```
