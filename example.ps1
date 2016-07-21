# Settings
$managementActionPointId = ""
$MonitorUniqueIdentifier = ""
$FolderItemID1 = ""
$FolderItemID2 = ""

$ID = "WebApplicationSelfDiagnosticsMonitoring"
$ManagementPackName = "_Web Application Self Diagnostics Monitoring"
$MonitoringName = "Web Application Self Diagnostics Monitoring"
$URLsToMonitor = @{
	"Example application 1 - app1.contoso.com" = "https://app1.contoso.com/monitoring.aspx";
	"Example application 2 - app2.contoso.com" = "https://app2.contoso.com/monitoring.aspx";
}

#########################################################################

$ScriptPath = Split-Path $script:MyInvocation.MyCommand.Path
[int]$LastVersionDigit = Get-Content "$ScriptPath\lastversion.txt"
$VersionDigit = $LastVersionDigit + 1
$Version = "1.0.0." + $VersionDigit

$OutputFolder = $ScriptPath
.\GenerateManagementPackForURLmonitors.ps1 -ID $ID -ManagementPackName $ManagementPackName -Version $Version -MonitorUniqueIdentifier $MonitorUniqueIdentifier `
-managementActionPointId $managementActionPointId -URLsToMonitor $URLsToMonitor -OutputFolder $OutputFolder `
-FolderItemID1 $FolderItemID1 -FolderItemID2 $FolderItemID2 `
-MonitoringName $MonitoringName # Not mandatory parameter

$VersionDigit | Out-File "$ScriptPath\lastversion.txt"

$ManagementPackNameFile = $OutputFolder + "\" + $ID + ".xml"
Import-SCManagementPack $ManagementPackNameFile