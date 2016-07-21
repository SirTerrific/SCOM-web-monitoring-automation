param(
	[Parameter(Mandatory=$true)][String]$ID,
	[Parameter(Mandatory=$true)][String]$ManagementPackName,
	[Parameter(Mandatory=$true)][String]$Version,
	[Parameter(Mandatory=$true)][String]$MonitorUniqueIdentifier,
	[Parameter(Mandatory=$false)][String]$MonitoringName = $ID,
	[Parameter(Mandatory=$true)][String]$managementActionPointId,
	[Parameter(Mandatory=$true)][hashtable]$URLsToMonitor,
	[Parameter(Mandatory=$false)][String]$IntervalSeconds = 86400,
	[Parameter(Mandatory=$true)][String]$OutputFolder,
	[Parameter(Mandatory=$true)][String]$FolderItemID1,
	[Parameter(Mandatory=$true)][String]$FolderItemID2
)

$InternalFolder = "TemplateoutputMicrosoftSystemCenterWebApplicationSolutionsSingleUrlTemplate" + $MonitorUniqueIdentifier
$VersionInfo = '<Identity><ID>' + $ID + '</ID><Version>' + $Version + '</Version></Identity><Name>' + $ManagementPackName + '</Name>'
$References = @'
    <References>
      <Reference Alias="SystemCenter">
        <ID>Microsoft.SystemCenter.Library</ID>
        <Version>7.0.8433.0</Version>
        <PublicKeyToken>31bf3856ad364e35</PublicKeyToken>
      </Reference>
      <Reference Alias="MicrosoftSystemCenterWebApplicationSolutionsLibrary">
        <ID>Microsoft.SystemCenter.WebApplicationSolutions.Library</ID>
        <Version>7.1.10226.0</Version>
        <PublicKeyToken>31bf3856ad364e35</PublicKeyToken>
      </Reference>
      <Reference Alias="System">
        <ID>System.Library</ID>
        <Version>7.5.8501.0</Version>
        <PublicKeyToken>31bf3856ad364e35</PublicKeyToken>
      </Reference>
    </References>
'@


$Monitoring = '<Monitoring>'
$Monitoring += '<Discoveries>'
$Monitoring += '<Discovery ID="Microsoft.SystemCenter.WebApplicationSolutions.' + $MonitorUniqueIdentifier + '.SingleUrlTestDiscovery" Enabled="onEssentialMonitoring" Target="Microsoft.SystemCenter.WebApplicationSolutions.SingleUrlUiTemplate.' + $MonitorUniqueIdentifier + '" ConfirmDelivery="false" Remotable="true" Priority="Normal">'
$Monitoring += @'
<Category>Discovery</Category>
<DiscoveryTypes>
    <DiscoveryClass TypeID="MicrosoftSystemCenterWebApplicationSolutionsLibrary!Microsoft.SystemCenter.WebApplicationSolutions.SingleUrlTest" />
    <DiscoveryRelationship TypeID="MicrosoftSystemCenterWebApplicationSolutionsLibrary!Microsoft.SystemCenter.WebApplicationSolutions.SingleUrlTest.IsMemberOf.SingleUrlUiTemplate" />
</DiscoveryTypes>
'@

$Monitoring += '<DataSource ID="DS" TypeID="MicrosoftSystemCenterWebApplicationSolutionsLibrary!Microsoft.SystemCenter.WebApplicationSolutions.SnapshotDiscovery.DS">'
$Monitoring += '<IntervalSeconds>' + $IntervalSeconds + '</IntervalSeconds>'
$Monitoring += '<ClassId>$MPElement[Name="MicrosoftSystemCenterWebApplicationSolutionsLibrary!Microsoft.SystemCenter.WebApplicationSolutions.SingleUrlTest"]$</ClassId><ClassInstanceSettings>'

$Settings = '<Settings>'
$Settings += '<Setting><Name>$MPElement[Name="System!System.Entity"]/DisplayName$</Name><Value>' + $MonitoringName + '</Value></Setting>'
$Settings += '<Setting><Name>$MPElement[Name="MicrosoftSystemCenterWebApplicationSolutionsLibrary!Microsoft.SystemCenter.WebApplicationSolutions.SingleUrlTest"]/InstanceId$</Name><Value>' + $MonitorUniqueIdentifier + '</Value></Setting>'
$Settings += '<Setting><Name>$MPElement[Name="MicrosoftSystemCenterWebApplicationSolutionsLibrary!Microsoft.SystemCenter.WebApplicationSolutions.SingleUrlTest"]/Locations$</Name><Value>&lt;Locations version="1.0"&gt;&lt;Location managementActionPointId="' + $managementActionPointId + '" /&gt;&lt;/Locations&gt;</Value></Setting>'

# Add URLs from hash table
$Settings += '<Setting><Name>$MPElement[Name="MicrosoftSystemCenterWebApplicationSolutionsLibrary!Microsoft.SystemCenter.WebApplicationSolutions.SingleUrlTest"]/Parameters$</Name>'
$Settings += '<Value>&lt;Parameters version="1.0"&gt;&lt;Parameter name="URL"&gt;'
ForEach ($row in $URLsToMonitor.GetEnumerator()) {
    $Settings += '&lt;Value displayName="' + $row.Name + '"&gt;' + $row.Value + '&lt;/Value&gt;'
}
$Settings += '&lt;/Parameter&gt;&lt;/Parameters&gt;</Value>'
$Settings += '</Setting>'

# FixMe: Add possibility to specify these settings
$Settings += @'     
  <Setting>
    <Name>$MPElement[Name="MicrosoftSystemCenterWebApplicationSolutionsLibrary!Microsoft.SystemCenter.WebApplicationSolutions.SingleUrlTest"]/TestConfig$</Name>
    <Value>&lt;TestConfig version="1.0"&gt;&lt;Requests&gt;&lt;Request&gt;&lt;RequestID&gt;1&lt;/RequestID&gt;&lt;URL&gt;$Parameter/URL$&lt;/URL&gt;&lt;HttpHeaders&gt;&lt;HttpHeader&gt;&lt;Name&gt;Accept&lt;/Name&gt;&lt;Value&gt;*/*&lt;/Value&gt;&lt;/HttpHeader&gt;&lt;HttpHeader&gt;&lt;Name&gt;Accept-Language&lt;/Name&gt;&lt;Value&gt;en-us&lt;/Value&gt;&lt;/HttpHeader&gt;&lt;HttpHeader&gt;&lt;Name&gt;Accept-Encoding&lt;/Name&gt;&lt;Value&gt;GZIP&lt;/Value&gt;&lt;/HttpHeader&gt;&lt;/HttpHeaders&gt;&lt;RequestEvaluationCriteria&gt;&lt;BasePageEvaluationCriteria&gt;&lt;WarningCriteria&gt;&lt;ResponseBodyCriteria&gt;&lt;RegExOperator&gt;ContainsSubstring&lt;/RegExOperator&gt;&lt;Value&gt;SLOWEXISTS&lt;/Value&gt;&lt;/ResponseBodyCriteria&gt;&lt;/WarningCriteria&gt;&lt;ErrorCriteria&gt;&lt;StatusCodeCriteria&gt;&lt;Operator&gt;NotEqual&lt;/Operator&gt;&lt;Value&gt;200&lt;/Value&gt;&lt;/StatusCodeCriteria&gt;&lt;ErrorCodeCriteria&gt;&lt;Operator&gt;NotEqual&lt;/Operator&gt;&lt;Value&gt;0&lt;/Value&gt;&lt;/ErrorCodeCriteria&gt;&lt;ResponseBodyCriteria&gt;&lt;RegExOperator&gt;DoesNotContainSubstring&lt;/RegExOperator&gt;&lt;Value&gt;SUCCESSFULLY&lt;/Value&gt;&lt;/ResponseBodyCriteria&gt;&lt;/ErrorCriteria&gt;&lt;/BasePageEvaluationCriteria&gt;&lt;ResourcesEvaluationCriteria&gt;&lt;ErrorCriteria&gt;&lt;StatusCodeListCriteria&gt;&lt;Operator&gt;GreaterEqual&lt;/Operator&gt;&lt;Value&gt;400&lt;/Value&gt;&lt;/StatusCodeListCriteria&gt;&lt;ErrorCodeListCriteria&gt;&lt;Operator&gt;NotEqual&lt;/Operator&gt;&lt;Value&gt;0&lt;/Value&gt;&lt;/ErrorCodeListCriteria&gt;&lt;/ErrorCriteria&gt;&lt;/ResourcesEvaluationCriteria&gt;&lt;/RequestEvaluationCriteria&gt;&lt;PerformanceCounters&gt;&lt;CollectDNSResolutionTime&gt;true&lt;/CollectDNSResolutionTime&gt;&lt;CollectTimeToFirstByte&gt;true&lt;/CollectTimeToFirstByte&gt;&lt;CollectTimeToLastByte&gt;true&lt;/CollectTimeToLastByte&gt;&lt;CollectContentSize&gt;true&lt;/CollectContentSize&gt;&lt;CollectContentTime&gt;true&lt;/CollectContentTime&gt;&lt;/PerformanceCounters&gt;&lt;/Request&gt;&lt;/Requests&gt;&lt;TransactionEvaluationCriteria&gt;&lt;ErrorCriteria&gt;&lt;ErrorCodeCriteria&gt;&lt;Operator&gt;NotEqual&lt;/Operator&gt;&lt;Value&gt;0&lt;/Value&gt;&lt;/ErrorCodeCriteria&gt;&lt;/ErrorCriteria&gt;&lt;/TransactionEvaluationCriteria&gt;&lt;CollectTransactionResponseTime&gt;true&lt;/CollectTransactionResponseTime&gt;&lt;/TestConfig&gt;</Value>
  </Setting>
  <Setting>
    <Name>$MPElement[Name="MicrosoftSystemCenterWebApplicationSolutionsLibrary!Microsoft.SystemCenter.WebApplicationSolutions.SingleUrlTest"]/IntervalInSeconds$</Name>
    <Value>600</Value>
  </Setting>
  <Setting>
    <Name>$MPElement[Name="MicrosoftSystemCenterWebApplicationSolutionsLibrary!Microsoft.SystemCenter.WebApplicationSolutions.SingleUrlTest"]/Alerting$</Name>
    <Value>false</Value>
  </Setting>
  <Setting>
    <Name>$MPElement[Name="MicrosoftSystemCenterWebApplicationSolutionsLibrary!Microsoft.SystemCenter.WebApplicationSolutions.SingleUrlTest"]/AlertingOnTest$</Name>
    <Value>true</Value>
  </Setting>
  <Setting>
    <Name>$MPElement[Name="MicrosoftSystemCenterWebApplicationSolutionsLibrary!Microsoft.SystemCenter.WebApplicationSolutions.SingleUrlTest"]/ConsecutiveMatchCount$</Name>
    <Value>1</Value>
  </Setting>
'@
$Settings += '</Settings>'

$Monitoring += $Settings
$Monitoring += @'
</ClassInstanceSettings>
<RelationshipId>$MPElement[Name="MicrosoftSystemCenterWebApplicationSolutionsLibrary!Microsoft.SystemCenter.WebApplicationSolutions.SingleUrlTest.IsMemberOf.SingleUrlUiTemplate"]$</RelationshipId>
'@
$Monitoring += '<SourceTypeId>$MPElement[Name="Microsoft.SystemCenter.WebApplicationSolutions.SingleUrlUiTemplate.' + $MonitorUniqueIdentifier + '"]$</SourceTypeId>'
$Monitoring += @'
<TargetTypeId>$MPElement[Name="MicrosoftSystemCenterWebApplicationSolutionsLibrary!Microsoft.SystemCenter.WebApplicationSolutions.SingleUrlTest"]$</TargetTypeId>
<TargetRoleSettings>
<Settings>
<Setting>
<Name>$MPElement[Name="MicrosoftSystemCenterWebApplicationSolutionsLibrary!Microsoft.SystemCenter.WebApplicationSolutions.SingleUrlTest"]/InstanceId$</Name>
'@
$Monitoring += '<Value>' + $MonitorUniqueIdentifier + '</Value>'
$Monitoring += '</Setting></Settings>'
$Monitoring += '</TargetRoleSettings>'


########### Generating UniquenessKey ###########
$UniquenessKey = '<UniquenessKey>' + $MonitorUniqueIdentifier + ';' + $ID + ';;'
$UniquenessKey += '&lt;Parameters version="1.0"&gt;'
$UniquenessKey += '&lt;Parameter name="URL"&gt;'
ForEach ($row in $URLsToMonitor.GetEnumerator()) {
    $UniquenessKey += '&lt;Value displayName="' + $row.Name + '"&gt;' + $row.Value + '&lt;/Value&gt;'
}

# FixMe: Add possibility to specify these settings
$UniquenessKey += '&lt;/Parameter&gt;&lt;/Parameters&gt;;&lt;Locations version="1.0"&gt;&lt;Location managementActionPointId="' + $managementActionPointId + '" /&gt;&lt;/Locations&gt;;600;&lt;TestConfig version="1.0"&gt;&lt;Requests&gt;&lt;Request&gt;&lt;RequestID&gt;1&lt;/RequestID&gt;&lt;URL&gt;$Parameter/URL$&lt;/URL&gt;&lt;HttpHeaders&gt;&lt;HttpHeader&gt;&lt;Name&gt;Accept&lt;/Name&gt;&lt;Value&gt;*/*&lt;/Value&gt;&lt;/HttpHeader&gt;&lt;HttpHeader&gt;&lt;Name&gt;Accept-Language&lt;/Name&gt;&lt;Value&gt;en-us&lt;/Value&gt;&lt;/HttpHeader&gt;&lt;HttpHeader&gt;&lt;Name&gt;Accept-Encoding&lt;/Name&gt;&lt;Value&gt;GZIP&lt;/Value&gt;&lt;/HttpHeader&gt;&lt;/HttpHeaders&gt;&lt;RequestEvaluationCriteria&gt;&lt;BasePageEvaluationCriteria&gt;&lt;WarningCriteria&gt;&lt;ResponseBodyCriteria&gt;&lt;RegExOperator&gt;ContainsSubstring&lt;/RegExOperator&gt;&lt;Value&gt;SLOWEXISTS&lt;/Value&gt;&lt;/ResponseBodyCriteria&gt;&lt;/WarningCriteria&gt;&lt;ErrorCriteria&gt;&lt;StatusCodeCriteria&gt;&lt;Operator&gt;NotEqual&lt;/Operator&gt;&lt;Value&gt;200&lt;/Value&gt;&lt;/StatusCodeCriteria&gt;&lt;ErrorCodeCriteria&gt;&lt;Operator&gt;NotEqual&lt;/Operator&gt;&lt;Value&gt;0&lt;/Value&gt;&lt;/ErrorCodeCriteria&gt;&lt;ResponseBodyCriteria&gt;&lt;RegExOperator&gt;DoesNotContainSubstring&lt;/RegExOperator&gt;&lt;Value&gt;SUCCESSFULLY&lt;/Value&gt;&lt;/ResponseBodyCriteria&gt;&lt;/ErrorCriteria&gt;&lt;/BasePageEvaluationCriteria&gt;&lt;ResourcesEvaluationCriteria&gt;&lt;ErrorCriteria&gt;&lt;StatusCodeListCriteria&gt;&lt;Operator&gt;GreaterEqual&lt;/Operator&gt;&lt;Value&gt;400&lt;/Value&gt;&lt;/StatusCodeListCriteria&gt;&lt;ErrorCodeListCriteria&gt;&lt;Operator&gt;NotEqual&lt;/Operator&gt;&lt;Value&gt;0&lt;/Value&gt;&lt;/ErrorCodeListCriteria&gt;&lt;/ErrorCriteria&gt;&lt;/ResourcesEvaluationCriteria&gt;&lt;/RequestEvaluationCriteria&gt;&lt;PerformanceCounters&gt;&lt;CollectDNSResolutionTime&gt;true&lt;/CollectDNSResolutionTime&gt;&lt;CollectTimeToFirstByte&gt;true&lt;/CollectTimeToFirstByte&gt;&lt;CollectTimeToLastByte&gt;true&lt;/CollectTimeToLastByte&gt;&lt;CollectContentSize&gt;true&lt;/CollectContentSize&gt;&lt;CollectContentTime&gt;true&lt;/CollectContentTime&gt;&lt;/PerformanceCounters&gt;&lt;/Request&gt;&lt;/Requests&gt;&lt;TransactionEvaluationCriteria&gt;&lt;ErrorCriteria&gt;&lt;ErrorCodeCriteria&gt;&lt;Operator&gt;NotEqual&lt;/Operator&gt;&lt;Value&gt;0&lt;/Value&gt;&lt;/ErrorCodeCriteria&gt;&lt;/ErrorCriteria&gt;&lt;/TransactionEvaluationCriteria&gt;&lt;CollectTransactionResponseTime&gt;true&lt;/CollectTransactionResponseTime&gt;&lt;/TestConfig&gt;;false;true;1</UniquenessKey>'
$Monitoring += $UniquenessKey

$Monitoring += '</DataSource></Discovery></Discoveries></Monitoring>'


$Presentation = '<Presentation><Folders>'
$Presentation += '<Folder ID="' + $InternalFolder + '" Accessibility="Internal" ParentFolder="MicrosoftSystemCenterWebApplicationSolutionsLibrary!Microsoft.SystemCenter.WebApplicationSolutions.SingleUrl.Template.Folder" />'
$Presentation += '</Folders><FolderItems>'
$Presentation += '<FolderItem ElementID="Microsoft.SystemCenter.WebApplicationSolutions.SingleUrlUiTemplate.' + $MonitorUniqueIdentifier + '" ID="' + $FolderItemID1 + '" Folder="' + $InternalFolder + '" />'
$Presentation += '<FolderItem ElementID="Microsoft.SystemCenter.WebApplicationSolutions.' + $MonitorUniqueIdentifier + '.SingleUrlTestDiscovery" ID="' + $FolderItemID2 + '" Folder="' + $InternalFolder + '" />'
$Presentation += '</FolderItems></Presentation>'

$LanguagePacks = '<LanguagePacks><LanguagePack ID="ENU" IsDefault="true"><DisplayStrings>'
$LanguagePacks += '<DisplayString ElementID="' + $ID + '"><Name>' + $ManagementPackName + '</Name></DisplayString>'
$LanguagePacks += '<DisplayString ElementID="' + $InternalFolder + '"><Name>' + $MonitoringName + '</Name></DisplayString>'
$LanguagePacks += '<DisplayString ElementID="Microsoft.SystemCenter.WebApplicationSolutions.SingleUrlUiTemplate.' + $MonitorUniqueIdentifier + '"><Name>' + $ManagementPackName + '</Name></DisplayString>'
$LanguagePacks += '<DisplayString ElementID="Microsoft.SystemCenter.WebApplicationSolutions.' + $MonitorUniqueIdentifier + '.SingleUrlTestDiscovery"><Name>' + $ManagementPackName + 'Discovery</Name></DisplayString>'
$LanguagePacks += '</DisplayStrings></LanguagePack></LanguagePacks>'



###### Putting everything together ######
$ManagementPackContent = @'
<?xml version="1.0" encoding="utf-8"?>
<ManagementPack ContentReadable="true" SchemaVersion="2.0" OriginalSchemaVersion="1.1" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
'@
$ManagementPackContent += "<Manifest>"
$ManagementPackContent += $VersionInfo
$ManagementPackContent += $References
$ManagementPackContent += "</Manifest>"
 
$TypeDefinitions = '<TypeDefinitions><EntityTypes><ClassTypes>'
$TypeDefinitions += '<ClassType ID="Microsoft.SystemCenter.WebApplicationSolutions.SingleUrlUiTemplate.' + $MonitorUniqueIdentifier + '"'
$TypeDefinitions += ' Accessibility="Public" Abstract="false" Base="MicrosoftSystemCenterWebApplicationSolutionsLibrary!Microsoft.SystemCenter.WebApplicationSolutions.SingleUrlUiTemplate" Hosted="false" Singleton="true" Extension="false" />'
$TypeDefinitions += '</ClassTypes></EntityTypes></TypeDefinitions>'

$ManagementPackContent += $TypeDefinitions 
$ManagementPackContent += $Monitoring
$ManagementPackContent += $Presentation
$ManagementPackContent += $LanguagePacks
$ManagementPackContent += '</ManagementPack>' 

# Export management pack
[xml]$ManagementPackXML = $ManagementPackContent
$OutputFile = $OutputFolder + "\" + $ID + ".xml"
$ManagementPackXML.Save($OutputFile)