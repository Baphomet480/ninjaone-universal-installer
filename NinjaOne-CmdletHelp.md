# NinjaOne PowerShell Cmdlet Reference
> Generated on 2025-07-31 11:49:57

## Connect-NinjaOne

**Synopsis**: Creates a new connection to a NinjaOne instance.

### Syntax
```powershell





```

### Parameters
* **UseWebAuth** — **(Required)** Use the "Authorisation Code" flow with your web browser.
* **UseTokenAuth** — Use the "Token Authentication" flow - useful if you already have a refresh token.
* **UseClientAuth** — Use the "Client Credentials" flow - useful if you already have a client ID and secret.
* **Instance** — **(Required)** The NinjaOne instance to connect to. Choose from 'eu', 'oc' or 'us'.
* **ClientId** — **(Required)** The Client Id for the application configured in NinjaOne.
* **ClientSecret** — **(Required)** The Client Secret for the application configured in NinjaOne.
* **Scopes** — The API scopes to request, if this isn't passed the scope is assumed to be "all". Pass a string or array of strings. Limited by the scopes granted to the application in NinjaOne.
* **RedirectURL** — The redirect URI to use. If not set defaults to 'http://localhost'. Should be a full URI e.g. https://redirect.example.uk:9090/auth
* **Port** — The port to use for the redirect URI. Must match with the configuration set in NinjaOne. If not set defaults to '9090'.
* **RefreshToken** — The refresh token to use for "Token Authentication" flow.
* **ShowTokens** — Output the tokens - useful when using "Authorisation Code" flow - to use with "Token Authentication" flow.
* **UseSecretManagement** — Use the secret management module to retrieve credentials and store tokens. Check the docs on setting up the secret management module at https://docs.homotechsual.dev/common/secretmanagement.
* **VaultName** — The name of the secret vault to use.
* **WriteToSecretVault** — Write updated credentials to secret management vault.
* **ReadFromSecretVault** — Read the authentication information from secret management vault.
* **SecretPrefix** — The prefix to add to the name of the secrets stored in the secret vault.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Connect-NinjaOne -Instance 'eu' -ClientId 'AAaaA1aaAaAA-aaAaaA11a1A-aA' -ClientSecret '00Z00zzZzzzZzZzZzZzZZZ0zZ0zzZ_0zzz0zZZzzZz0Z0ZZZzz0z0Z' -UseClientAuth
```

**-------------------------- EXAMPLE 2 --------------------------**
```powershell
Connect-NinjaOne -Instance 'eu' -ClientId 'AAaaA1aaAaAA-aaAaaA11a1A-aA' -ClientSecret '00Z00zzZzzzZzZzZzZzZZZ0zZ0zzZ_0zzz0zZZzzZz0Z0ZZZzz0z0Z' -Port 9090 -UseWebAuth
```

**-------------------------- EXAMPLE 3 --------------------------**
```powershell
Connect-NinjaOne -Instance 'eu' -ClientId 'AAaaA1aaAaAA-aaAaaA11a1A-aA' -ClientSecret '00Z00zzZzzzZzZzZzZzZZZ0zZ0zzZ_0zzz0zZZzzZz0Z0ZZZzz0z0Z' -RefreshToken 'a1a11a11-aa11-11a1-a111-a1a111aaa111.11AaaAaaa11aA-AA1aaaAAA111aAaaaaA1AAAA1_AAa' -UseTokenAuth
```

**-------------------------- EXAMPLE 4 --------------------------**
```powershell
Connect-NinjaOne -UseSecretManagement -VaultName 'NinjaOneVault' -WriteToSecretVault -Instance 'eu' -ClientId 'AAaaA1aaAaAA-aaAaaA11a1A-aA' -ClientSecret '00Z00zzZzzzZzZzZzZzZZZ0zZ0zzZ_0zzz0zZZzzZz0Z0ZZZzz0z0Z' -UseClientAuth
```

**-------------------------- EXAMPLE 5 --------------------------**
```powershell
Connect-NinjaOne -UseSecretManagement -VaultName 'NinjaOneVault' -ReadFromSecretVault
```

---

## Find-NinjaOneDevice

**Synopsis**: Searches for devices from the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **limit** — Limit number of devices to return.
* **searchQuery** — **(Required)** Search query

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Find-NinjaOneDevices -limit 10 -searchQuery 'ABCD'
```

**-------------------------- EXAMPLE 2 --------------------------**
```powershell
(Find-NinjaOneDevices -limit 10 -searchQuery 'ABCD').devices
```

---

## Find-NinjaOneDevices

**Synopsis**: Searches for devices from the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **limit** — Limit number of devices to return.
* **searchQuery** — **(Required)** Search query

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Find-NinjaOneDevices -limit 10 -searchQuery 'ABCD'
```

**-------------------------- EXAMPLE 2 --------------------------**
```powershell
(Find-NinjaOneDevices -limit 10 -searchQuery 'ABCD').devices
```

---

## Get-NinjaOneActivities

**Synopsis**: Gets activities from the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **deviceId** — Filter by device id.
* **class** — Activity class.
* **before** — return activities from before this date. PowerShell DateTime object.
* **beforeUnixEpoch** — return activities from before this date. Unix Epoch time.
* **after** — return activities from after this date. PowerShell DateTime object.
* **afterUnixEpoch** — return activities from after this date. Unix Epoch time.
* **olderThan** — return activities older than this activity id.
* **newerThan** — return activities newer than this activity id.
* **type** — return activities of this type.
* **activityType** — return activities of this type.
* **status** — return activities with this status.
* **user** — return activities for this user.
* **seriesUid** — return activities for this alert series.
* **deviceFilter** — return activities matching this device filter.
* **pageSize** — Number of results per page.
* **languageTag** — Filter by language tag.
* **timeZone** — Filter by timezone.
* **sourceConfigUid** — return activities for this source configuration.
* **expandActivities** — return the activities object instead of the default return with `lastActivityId` and `activities` properties.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneActivities
```

**-------------------------- EXAMPLE 2 --------------------------**
```powershell
Get-NinjaOneActivities -deviceId 1
```

**-------------------------- EXAMPLE 3 --------------------------**
```powershell
Get-NinjaOneActivities -class SYSTEM
```

**-------------------------- EXAMPLE 4 --------------------------**
```powershell
Get-NinjaOneActivities -before ([DateTime]::Now.AddDays(-1))
```

**-------------------------- EXAMPLE 5 --------------------------**
```powershell
Get-NinjaOneActivities -after ([DateTime]::Now.AddDays(-1))
```

**-------------------------- EXAMPLE 6 --------------------------**
```powershell
Get-NinjaOneActivities -olderThan 1
```

**-------------------------- EXAMPLE 7 --------------------------**
```powershell
Get-NinjaOneActivities -newerThan 1
```

**-------------------------- EXAMPLE 8 --------------------------**
```powershell
Get-NinjaOneActivities -type 'Action'
```

**-------------------------- EXAMPLE 9 --------------------------**
```powershell
Get-NinjaOneActivities -status 'COMPLETED'
```

**-------------------------- EXAMPLE 10 --------------------------**
```powershell
Get-NinjaOneActivities -seriesUid '23e4567-e89b-12d3-a456-426614174000'
```

**-------------------------- EXAMPLE 11 --------------------------**
```powershell
Get-NinjaOneActivities -deviceFilter 'organization in (1,2,3)'
```

---

## Get-NinjaOneActivity

**Synopsis**: Gets activities from the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **deviceId** — Filter by device id.
* **class** — Activity class.
* **before** — return activities from before this date. PowerShell DateTime object.
* **beforeUnixEpoch** — return activities from before this date. Unix Epoch time.
* **after** — return activities from after this date. PowerShell DateTime object.
* **afterUnixEpoch** — return activities from after this date. Unix Epoch time.
* **olderThan** — return activities older than this activity id.
* **newerThan** — return activities newer than this activity id.
* **type** — return activities of this type.
* **activityType** — return activities of this type.
* **status** — return activities with this status.
* **user** — return activities for this user.
* **seriesUid** — return activities for this alert series.
* **deviceFilter** — return activities matching this device filter.
* **pageSize** — Number of results per page.
* **languageTag** — Filter by language tag.
* **timeZone** — Filter by timezone.
* **sourceConfigUid** — return activities for this source configuration.
* **expandActivities** — return the activities object instead of the default return with `lastActivityId` and `activities` properties.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneActivities
```

**-------------------------- EXAMPLE 2 --------------------------**
```powershell
Get-NinjaOneActivities -deviceId 1
```

**-------------------------- EXAMPLE 3 --------------------------**
```powershell
Get-NinjaOneActivities -class SYSTEM
```

**-------------------------- EXAMPLE 4 --------------------------**
```powershell
Get-NinjaOneActivities -before ([DateTime]::Now.AddDays(-1))
```

**-------------------------- EXAMPLE 5 --------------------------**
```powershell
Get-NinjaOneActivities -after ([DateTime]::Now.AddDays(-1))
```

**-------------------------- EXAMPLE 6 --------------------------**
```powershell
Get-NinjaOneActivities -olderThan 1
```

**-------------------------- EXAMPLE 7 --------------------------**
```powershell
Get-NinjaOneActivities -newerThan 1
```

**-------------------------- EXAMPLE 8 --------------------------**
```powershell
Get-NinjaOneActivities -type 'Action'
```

**-------------------------- EXAMPLE 9 --------------------------**
```powershell
Get-NinjaOneActivities -status 'COMPLETED'
```

**-------------------------- EXAMPLE 10 --------------------------**
```powershell
Get-NinjaOneActivities -seriesUid '23e4567-e89b-12d3-a456-426614174000'
```

**-------------------------- EXAMPLE 11 --------------------------**
```powershell
Get-NinjaOneActivities -deviceFilter 'organization in (1,2,3)'
```

---

## Get-NinjaOneAlert

**Synopsis**: Gets alerts from the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **deviceId** — Filter by device id.
* **sourceType** — Filter by source type.
* **deviceFilter** — Filter by device which triggered the alert.
* **languageTag** — Filter by language tag.
* **timeZone** — Filter by timezone.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneAlerts
```

**-------------------------- EXAMPLE 2 --------------------------**
```powershell
Get-NinjaOneAlerts -sourceType 'CONDITION_CUSTOM_FIELD'
```

**-------------------------- EXAMPLE 3 --------------------------**
```powershell
Get-NinjaOneAlerts -deviceFilter 'status eq APPROVED'
```

---

## Get-NinjaOneAlerts

**Synopsis**: Gets alerts from the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **deviceId** — Filter by device id.
* **sourceType** — Filter by source type.
* **deviceFilter** — Filter by device which triggered the alert.
* **languageTag** — Filter by language tag.
* **timeZone** — Filter by timezone.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneAlerts
```

**-------------------------- EXAMPLE 2 --------------------------**
```powershell
Get-NinjaOneAlerts -sourceType 'CONDITION_CUSTOM_FIELD'
```

**-------------------------- EXAMPLE 3 --------------------------**
```powershell
Get-NinjaOneAlerts -deviceFilter 'status eq APPROVED'
```

---

## Get-NinjaOneAntiVirusStatus

**Synopsis**: Gets the antivirus status from the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **deviceFilter** — Filter devices.
* **timeStamp** — Monitoring timestamp filter.
* **timeStampUnixEpoch** — Monitoring timestamp filter in unix time.
* **productState** — Filter by product state.
* **productName** — Filter by product name.
* **cursor** — Cursor name.
* **pageSize** — Number of results per page.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneAntivirusStatus -deviceFilter 'org = 1'
```

**-------------------------- EXAMPLE 2 --------------------------**
```powershell
Get-NinjaOneAntivirusStatus -timeStamp 1619712000
```

**-------------------------- EXAMPLE 3 --------------------------**
```powershell
Get-NinjaOneAntivirusStatus -productState 'ON'
```

**-------------------------- EXAMPLE 4 --------------------------**
```powershell
Get-NinjaOneAntivirusStatus -productName 'Microsoft Defender Antivirus'
```

---

## Get-NinjaOneAntiVirusThreats

**Synopsis**: Gets the antivirus threats from the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **deviceFilter** — Filter devices.
* **timeStamp** — Monitoring timestamp filter.
* **timeStampUnixEpoch** — Monitoring timestamp filter in unix time.
* **cursor** — Cursor name.
* **pageSize** — Number of results per page.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneAntivirusThreats
```

**-------------------------- EXAMPLE 2 --------------------------**
```powershell
Get-NinjaOneAntivirusThreats -deviceFilter 'org = 1'
```

---

## Get-NinjaOneAutomation

**Synopsis**: Gets automation scripts from the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **languageTag** — Return built in automation script names in the given language.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneAutomations
```

**-------------------------- EXAMPLE 2 --------------------------**
```powershell
Get-NinjaOneAlerts -lang 'en'
```

---

## Get-NinjaOneAutomations

**Synopsis**: Gets automation scripts from the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **languageTag** — Return built in automation script names in the given language.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneAutomations
```

**-------------------------- EXAMPLE 2 --------------------------**
```powershell
Get-NinjaOneAlerts -lang 'en'
```

---

## Get-NinjaOneAutomationScript

**Synopsis**: Gets automation scripts from the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **languageTag** — Return built in automation script names in the given language.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneAutomations
```

**-------------------------- EXAMPLE 2 --------------------------**
```powershell
Get-NinjaOneAlerts -lang 'en'
```

---

## Get-NinjaOneAutomationScripts

**Synopsis**: Gets automation scripts from the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **languageTag** — Return built in automation script names in the given language.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneAutomations
```

**-------------------------- EXAMPLE 2 --------------------------**
```powershell
Get-NinjaOneAlerts -lang 'en'
```

---

## Get-NinjaOneBackupJobs

**Synopsis**: Gets backup jobs from the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **cursor** — Cursor name.
* **deletedDeviceFilter** — Deleted device filter.
* **deviceFilter** — Device filter.
* **include** — Which devices to include (defaults to 'active').
* **pageSize** — Number of results per page.
* **planType** — Filter by plan type. See the supplemental documentation at https://docs.homotechsual.dev/modules/ninjaone/filters/ptf
* **planTypeFilter** — Raw plan type filter. See the supplemental documentation at https://docs.homotechsual.dev/modules/ninjaone/filters/ptf
* **status** — Filter by status. See the supplemental documentation at https://docs.homotechsual.dev/modules/ninjaone/filters/sf
* **statusFilter** — Raw status filter. See the supplemental documentation at https://docs.homotechsual.dev/modules/ninjaone/filters/sf
* **startTimeBetween** — Start time between filter. See the supplemental documentation at https://docs.homotechsual.dev/modules/ninjaone/filters/stf
* **startTimeAfter** — Start time after filter. See the supplemental documentation at https://docs.homotechsual.dev/modules/ninjaone/filters/stf
* **startTimeFilter** — Raw start time filter. See the supplemental documentation at https://docs.homotechsual.dev/modules/ninjaone/filters/stf

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneBackupJobs
```

**-------------------------- EXAMPLE 2 --------------------------**
```powershell
Get-NinjaOneBackupJobs -status 'RUNNING'
```

**-------------------------- EXAMPLE 3 --------------------------**
```powershell
Get-NinjaOneBackupJobs -status 'RUNNING', 'COMPLETED'
```

**-------------------------- EXAMPLE 4 --------------------------**
```powershell
Get-NinjaOneBackupJobs -statusFilter 'status = RUNNING'
```

**-------------------------- EXAMPLE 5 --------------------------**
```powershell
Get-NinjaOneBackupJobs -statusFilter 'status in (RUNNING, COMPLETED)'
```

**-------------------------- EXAMPLE 6 --------------------------**
```powershell
Get-NinjaOneBackupJobs -planType 'IMAGE'
```

**-------------------------- EXAMPLE 7 --------------------------**
```powershell
Get-NinjaOneBackupJobs -planType 'IMAGE', 'FILE_FOLDER'
```

**-------------------------- EXAMPLE 8 --------------------------**
```powershell
Get-NinjaOneBackupJobs -planTypeFilter 'planType = IMAGE'
```

**-------------------------- EXAMPLE 9 --------------------------**
```powershell
Get-NinjaOneBackupJobs -planTypeFilter 'planType in (IMAGE, FILE_FOLDER)'
```

**-------------------------- EXAMPLE 10 --------------------------**
```powershell
Get-NinjaOneBackupJobs -startTimeBetween (Get-Date).AddDays(-1), (Get-Date)
```

**-------------------------- EXAMPLE 11 --------------------------**
```powershell
Get-NinjaOneBackupJobs -startTimeAfter (Get-Date).AddDays(-1)
```

**-------------------------- EXAMPLE 12 --------------------------**
```powershell
Get-NinjaOneBackupJobs -startTimeFilter 'startTime between(2024-01-01T00:00:00.000Z,2024-01-02T00:00:00.000Z)'
```

**-------------------------- EXAMPLE 13 --------------------------**
```powershell
Get-NinjaOneBackupJobs -startTimeFilter 'startTime after 2024-01-01T00:00:00.000Z'
```

**-------------------------- EXAMPLE 14 --------------------------**
```powershell
Get-NinjaOneBackupJobs -deviceFilter all
```

---

## Get-NinjaOneBackupUsage

**Synopsis**: Gets the backup usage by device from the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **cursor** — Cursor name.
* **pageSize** — Number of results per page.
* **includeDeleted** — Include deleted devices.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneBackupUsage
```

**-------------------------- EXAMPLE 2 --------------------------**
```powershell
Get-NinjaOneBackupUsage -includeDeleted
```

**-------------------------- EXAMPLE 3 --------------------------**
```powershell
Get-NinjaOneBackupUsage | Where-Object { ($_.references.backupUsage.cloudTotalSize -ne 0) -or ($_.references.backupUsage.localTotalSize -ne 0) }
```

**-------------------------- EXAMPLE 4 --------------------------**
```powershell
Get-NinjaOneBackupUsage -includeDeleted | Where-Object { ($_.references.backupUsage.cloudTotalSize -ne 0) -and ($_.references.backupUsage.localTotalSize -ne 0) -and ($_.references.backupUsage.revisionsTotalSize -ne 0) }
```

---

## Get-NinjaOneComputerSystems

**Synopsis**: Gets the computer systems from the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **deviceFilter** — Filter devices.
* **timeStamp** — Monitoring timestamp filter.
* **timeStampUnixEpoch** — Monitoring timestamp filter in unix time.
* **cursor** — Cursor name.
* **pageSize** — Number of results per page.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneComputerSystems
```

**-------------------------- EXAMPLE 2 --------------------------**
```powershell
Get-NinjaOneComputerSystems -deviceFilter 'org = 1'
```

**-------------------------- EXAMPLE 3 --------------------------**
```powershell
Get-NinjaOneComputerSystems -timeStamp 1619712000
```

---

## Get-NinjaOneContacts

**Synopsis**: Gets contacts from the NinjaOne API.

### Syntax
```powershell

```

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneContacts
```

---

## Get-NinjaOneCustomFields

**Synopsis**: Gets the custom fields from the NinjaOne API.

### Syntax
```powershell


```

### Parameters
* **deviceFilter** — Filter devices.
* **cursor** — Cursor name.
* **pageSize** — Number of results per page.
* **scopes** — Custom field scopes to filter by.
* **updatedAfter** — Custom fields updated after the specified date. PowerShell DateTime object.
* **updatedAfterUnixEpoch** — Custom fields updated after the specified date. Unix Epoch time.
* **fields** — Array of fields.
* **detailed** — Get the detailed custom fields report(s).

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneCustomFields
```

**-------------------------- EXAMPLE 2 --------------------------**
```powershell
Get-NinjaOneCustomFields -deviceFilter 'org = 1'
```

**-------------------------- EXAMPLE 3 --------------------------**
```powershell
Get-NinjaOneCustomFields -updatedAfter (Get-Date).AddDays(-1)
```

**-------------------------- EXAMPLE 4 --------------------------**
```powershell
Get-NinjaOneCustomFields -updatedAfterUnixEpoch 1619712000
```

**-------------------------- EXAMPLE 5 --------------------------**
```powershell
Get-NinjaOneCustomFields -fields 'hasBatteries', 'autopilotHwid'
```

**-------------------------- EXAMPLE 6 --------------------------**
```powershell
Get-NinjaOneCustomFields -detailed
```

---

## Get-NinjaOneCustomFieldSignedURLs

**Synopsis**: Gets custom field signed URLs from the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **clientDocumentId** — **(Required)** The client document id to get signed URLs for.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneCustomFieldSignedURLs -entityType 'ORGANIZATION' -entityId 1
```

---

## Get-NinjaOneCustomFieldsPolicyCondition

**Synopsis**: Gets detailed information on a single custom field condition for a given policy from the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **policyId** — **(Required)** The policy id to get the custom field conditions for.
* **conditionId** — **(Required)** The condition id to get the custom field condition for.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneCustomFieldsPolicyCondition -policyId 1 -conditionId 1
```

---

## Get-NinjaOneCustomFieldsPolicyConditions

**Synopsis**: Gets custom field conditions for a given policy from the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **policyId** — **(Required)** The policy id to get the custom field conditions for.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneCustomFieldsPolicyConditions -policyId 1
```

---

## Get-NinjaOneDevice

**Synopsis**: Gets devices from the NinjaOne API.

### Syntax
```powershell



```

### Parameters
* **deviceId** — **(Required)** Device id to retrieve
* **deviceFilter** — Filter devices.
* **pageSize** — Number of results per page.
* **after** — Start results from device id.
* **detailed** — Include locations and policy mappings.
* **organisationId** — **(Required)** Filter by organisation id.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneDevices
```

**-------------------------- EXAMPLE 2 --------------------------**
```powershell
Get-NinjaOneDevices -deviceId 1
```

**-------------------------- EXAMPLE 3 --------------------------**
```powershell
Get-NinjaOneDevices -organisationId 1
```

**-------------------------- EXAMPLE 4 --------------------------**
```powershell
Get-NinjaOneDevices -deviceFilter 'status eq APPROVED'
```

**-------------------------- EXAMPLE 5 --------------------------**
```powershell
Get-NinjaOneDevices -deviceFilter 'class in (WINDOWS_WORKSTATION,MAC,LINUX_WORKSTATION)'
```

**-------------------------- EXAMPLE 6 --------------------------**
```powershell
Get-NinjaOneDevices -deviceFilter 'class eq WINDOWS_WORKSTATION AND online'
```

---

## Get-NinjaOneDeviceActivities

**Synopsis**: Wrapper command using `Get-NinjaOneActivities` to get activities for a device.

### Syntax
```powershell

```

### Parameters
* **deviceId** — **(Required)** Filter by device id.
* **languageTag** — Return built in job names in the given language.
* **timezone** — Return job times/dates in the given timezone.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneDeviceActivities -deviceId 1
```

---

## Get-NinjaOneDeviceAlerts

**Synopsis**: Wrapper command using `Get-NinjaOneAlerts` to get alerts for a device.

### Syntax
```powershell

```

### Parameters
* **deviceId** — **(Required)** Filter by device id.
* **languageTag** — Return built in condition names in the given language.
* **timezone** — Return alert times/dates in the given timezone.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneDeviceAlerts -deviceId 1
```

---

## Get-NinjaOneDeviceBackupUsage

**Synopsis**: Gets the backup usage by device from the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **cursor** — Cursor name.
* **pageSize** — Number of results per page.
* **includeDeleted** — Include deleted devices.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneBackupUsage
```

**-------------------------- EXAMPLE 2 --------------------------**
```powershell
Get-NinjaOneBackupUsage -includeDeleted
```

**-------------------------- EXAMPLE 3 --------------------------**
```powershell
Get-NinjaOneBackupUsage | Where-Object { ($_.references.backupUsage.cloudTotalSize -ne 0) -or ($_.references.backupUsage.localTotalSize -ne 0) }
```

**-------------------------- EXAMPLE 4 --------------------------**
```powershell
Get-NinjaOneBackupUsage -includeDeleted | Where-Object { ($_.references.backupUsage.cloudTotalSize -ne 0) -and ($_.references.backupUsage.localTotalSize -ne 0) -and ($_.references.backupUsage.revisionsTotalSize -ne 0) }
```

---

## Get-NinjaOneDeviceCustomFields

**Synopsis**: Gets device custom fields from the NinjaOne API.

### Syntax
```powershell


```

### Parameters
* **deviceId** — **(Required)** Device id to get custom field values for a specific device.
* **scope** — The scopes to get custom field definitions for.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneDeviceCustomFields
```

**-------------------------- EXAMPLE 2 --------------------------**
```powershell
Get-NinjaOneDeviceCustomFields | Group-Object { $_.scope }
```

**-------------------------- EXAMPLE 3 --------------------------**
```powershell
Get-NinjaOneDeviceCustomFields -deviceId 1
```

**-------------------------- EXAMPLE 4 --------------------------**
```powershell
Get-NinjaOneDeviceCustomFields -deviceId 1 -withInheritance
```

---

## Get-NinjaOneDeviceDashboardURL

**Synopsis**: Gets device dashboard URL from the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **deviceId** — **(Required)** The device id to get the dashboard URL for.
* **redirect** — return redirect response. This is largely useless as it will return a HTML redirect page source.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneDeviceDashboardURL -deviceId 1
```

---

## Get-NinjaOneDeviceDiskDrives

**Synopsis**: Gets device disks from the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **deviceId** — **(Required)** Device id to get disk information for.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneDeviceDisks -deviceId 1
```

---

## Get-NinjaOneDeviceDisks

**Synopsis**: Gets device disks from the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **deviceId** — **(Required)** Device id to get disk information for.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneDeviceDisks -deviceId 1
```

---

## Get-NinjaOneDeviceHealth

**Synopsis**: Gets the device health from the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **deviceFilter** — Filter devices.
* **health** — Filter by health status.
* **cursor** — Cursor name.
* **pageSize** — Number of results per page.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneDeviceHealth
```

**-------------------------- EXAMPLE 2 --------------------------**
```powershell
Get-NinjaOneDeviceHealth -deviceFilter 'org = 1'
```

**-------------------------- EXAMPLE 3 --------------------------**
```powershell
Get-NinjaOneDeviceHealth -health 'UNHEALTHY'
```

---

## Get-NinjaOneDeviceJobs

**Synopsis**: Wrapper command using `Get-NinjaOneJobs` to get jobs for a device.

### Syntax
```powershell

```

### Parameters
* **deviceId** — **(Required)** Filter by device id.
* **languageTag** — Return built in job names in the given language.
* **timezone** — Return job times/dates in the given timezone.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneDeviceJobs -deviceId 1
```

---

## Get-NinjaOneDeviceLastLoggedOnUser

**Synopsis**: Gets device last logged on user from the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **deviceId** — **(Required)** Device id to get the last logged on user for.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneDeviceLastLoggedOnUser -deviceId 1
```

---

## Get-NinjaOneDeviceLink

**Synopsis**: Gets device dashboard URL from the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **deviceId** — **(Required)** The device id to get the dashboard URL for.
* **redirect** — return redirect response. This is largely useless as it will return a HTML redirect page source.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneDeviceDashboardURL -deviceId 1
```

---

## Get-NinjaOneDeviceNetworkInterfaces

**Synopsis**: Gets device network interfaces from the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **deviceId** — **(Required)** Device id to get the network interfaces for.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneDeviceNetworkInterfaces -deviceId 1
```

---

## Get-NinjaOneDeviceOSPatches

**Synopsis**: Gets device OS patches from the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **deviceId** — **(Required)** Device id to get OS patch information for.
* **status** — Filter returned patches by patch status.
* **type** — Filter returned patches by type.
* **severity** — Filter returned patches by severity.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneDeviceOSPatches -deviceId 1
```

**-------------------------- EXAMPLE 2 --------------------------**
```powershell
Get-NinjaOneDeviceOSPatches -deviceId 1 -status 'APPROVED' -type 'SECURITY_UPDATES' -severity 'CRITICAL'
```

---

## Get-NinjaOneDeviceOSPatchInstalls

**Synopsis**: Gets device OS patch installs from the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **deviceId** — **(Required)** Device id to get OS patch install information for.
* **status** — Filter patches by patch status.
* **installedBefore** — Filter patches to those installed before this date. Expects DateTime or Int.
* **installedBeforeUnixEpoch** — Filter patches to those installed after this date. Unix Epoch time.
* **installedAfter** — Filter patches to those installed after this date. Expects DateTime or Int.
* **installedAfterUnixEpoch** — Filter patches to those installed after this date. Unix Epoch time.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneDeviceOSPatchInstalls -deviceId 1
```

**-------------------------- EXAMPLE 2 --------------------------**
```powershell
Get-NinjaOneDeviceOSPatchInstalls -deviceId 1 -status 'FAILED' -installedAfter (Get-Date 2022/01/01)
```

---

## Get-NinjaOneDevicePolicyOverrides

**Synopsis**: Gets device policy overrides from the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **deviceId** — **(Required)** Device id to get the policy overrides for.
* **expandOverrides** — Expand the overrides property.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneDevicePolicyOverrides -deviceId 1
```

---

## Get-NinjaOneDeviceProcessors

**Synopsis**: Gets device processors from the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **deviceId** — **(Required)** Device id to get processor information for.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneDeviceProcessors -deviceId 1
```

---

## Get-NinjaOneDeviceRole

**Synopsis**: Gets device roles from the NinjaOne API.

### Syntax
```powershell

```

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneRoles
```

---

## Get-NinjaOneDeviceRoles

**Synopsis**: Gets device roles from the NinjaOne API.

### Syntax
```powershell

```

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneRoles
```

---

## Get-NinjaOneDevices

**Synopsis**: Gets devices from the NinjaOne API.

### Syntax
```powershell



```

### Parameters
* **deviceId** — **(Required)** Device id to retrieve
* **deviceFilter** — Filter devices.
* **pageSize** — Number of results per page.
* **after** — Start results from device id.
* **detailed** — Include locations and policy mappings.
* **organisationId** — **(Required)** Filter by organisation id.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneDevices
```

**-------------------------- EXAMPLE 2 --------------------------**
```powershell
Get-NinjaOneDevices -deviceId 1
```

**-------------------------- EXAMPLE 3 --------------------------**
```powershell
Get-NinjaOneDevices -organisationId 1
```

**-------------------------- EXAMPLE 4 --------------------------**
```powershell
Get-NinjaOneDevices -deviceFilter 'status eq APPROVED'
```

**-------------------------- EXAMPLE 5 --------------------------**
```powershell
Get-NinjaOneDevices -deviceFilter 'class in (WINDOWS_WORKSTATION,MAC,LINUX_WORKSTATION)'
```

**-------------------------- EXAMPLE 6 --------------------------**
```powershell
Get-NinjaOneDevices -deviceFilter 'class eq WINDOWS_WORKSTATION AND online'
```

---

## Get-NinjaOneDeviceScriptingOptions

**Synopsis**: Gets device scripting options from the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **deviceId** — **(Required)** The device id to get the scripting options for.
* **LanguageTag** — Built in scripts / job names should be returned in the specified language.
* **Categories** — Return the categories list only.
* **Scripts** — Return the scripts list only.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneDeviceScriptingOptions -deviceId 1
```

**-------------------------- EXAMPLE 2 --------------------------**
```powershell
Get-NinjaOneDeviceScriptingOptions -deviceId 1 -Scripts
```

**-------------------------- EXAMPLE 3 --------------------------**
```powershell
Get-NinjaOneDeviceScriptingOptions -deviceId 1 -Categories
```

---

## Get-NinjaOneDeviceSoftware

**Synopsis**: Wrapper command using `Get-NinjaOneSoftwareProducts` to get installed software products for a device.

### Syntax
```powershell

```

### Parameters
* **deviceId** — **(Required)** Filter by device id.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneDeviceAlerts -deviceId 1
```

---

## Get-NinjaOneDeviceSoftwareInventory

**Synopsis**: Wrapper command using `Get-NinjaOneSoftwareProducts` to get installed software products for a device.

### Syntax
```powershell

```

### Parameters
* **deviceId** — **(Required)** Filter by device id.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneDeviceAlerts -deviceId 1
```

---

## Get-NinjaOneDeviceSoftwarePatches

**Synopsis**: Gets device Software patches from the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **deviceId** — **(Required)** Device id to get software patch information for.
* **status** — Filter patches by patch status.
* **productIdentifier** — Filter patches by product identifier.
* **type** — Filter patches by type.
* **impact** — Filter patches by impact.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneDeviceSoftwarePatches -deviceId 1
```

**-------------------------- EXAMPLE 2 --------------------------**
```powershell
Get-NinjaOneDeviceSoftwarePatches -deviceId 1 -status 'APPROVED' -type 'PATCH' -impact 'CRITICAL'
```

---

## Get-NinjaOneDeviceSoftwarePatchInstalls

**Synopsis**: Gets device software patch installs from the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **deviceId** — **(Required)** Device id to get software patch install information for.
* **type** — Filter patches by type.
* **impact** — Filter patches by impact.
* **status** — Filter patches by patch status.
* **productIdentifier** — Filter patches by product identifier.
* **installedBefore** — Filter patches to those installed before this date. PowerShell DateTime object.
* **installedBeforeUnixEpoch** — Filter patches to those installed after this date. Unix Epoch time.
* **installedAfter** — Filter patches to those installed after this date. PowerShell DateTime object.
* **installedAfterUnixEpoch** — Filter patches to those installed after this date. Unix Epoch time.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneDeviceSoftwarePatchInstalls -deviceId 1
```

**-------------------------- EXAMPLE 2 --------------------------**
```powershell
Get-NinjaOneDeviceSoftwarePatchInstalls -deviceId 1 -type 'PATCH' -impact 'RECOMMENDED' -status 'FAILED' -installedAfter (Get-Date 2022/01/01)
```

---

## Get-NinjaOneDeviceStorageVolumes

**Synopsis**: Gets device volumes from the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **deviceId** — **(Required)** Device id to get volumes for.
* **include** — Additional information to include currently known options are 'bl' for BitLocker status.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneDeviceVolumes -deviceId 1
```

**-------------------------- EXAMPLE 2 --------------------------**
```powershell
Get-NinjaOneDeviceVolumes -deviceId 1 -include bl
```

---

## Get-NinjaOneDeviceVolumes

**Synopsis**: Gets device volumes from the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **deviceId** — **(Required)** Device id to get volumes for.
* **include** — Additional information to include currently known options are 'bl' for BitLocker status.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneDeviceVolumes -deviceId 1
```

**-------------------------- EXAMPLE 2 --------------------------**
```powershell
Get-NinjaOneDeviceVolumes -deviceId 1 -include bl
```

---

## Get-NinjaOneDeviceWindowsServices

**Synopsis**: Gets device windows services from the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **deviceId** — **(Required)** Device id to get windows services for.
* **name** — Filter by service name. Ninja interprets this case sensitively.
* **state** — Filter by service state.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneDeviceWindowsServices -deviceId 1
```

**-------------------------- EXAMPLE 2 --------------------------**
```powershell
Get-NinjaOneDeviceWindowsServices -deviceId 1 -name 'NinjaRMM Agent'
```

**-------------------------- EXAMPLE 3 --------------------------**
```powershell
Get-NinjaOneDeviceWindowsServices -deviceId 1 -state 'RUNNING'
```

---

## Get-NinjaOneDisks

**Synopsis**: Gets the disks from the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **deviceFilter** — Filter devices.
* **timeStamp** — Monitoring timestamp filter.
* **timeStampUnixEpoch** — Monitoring timestamp filter in unix time.
* **cursor** — Cursor name.
* **pageSize** — Number of results per page.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneDisks
```

**-------------------------- EXAMPLE 2 --------------------------**
```powershell
Get-NinjaOneDisks -deviceFilter 'org = 1'
```

**-------------------------- EXAMPLE 3 --------------------------**
```powershell
Get-NinjaOneDisks -timeStamp 1619712000
```

---

## Get-NinjaOneDocumentTemplate

**Synopsis**: Gets one or more document templates from the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **documentTemplateId** — The document template id to retrieve.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneDocumentTemplate
```

**-------------------------- EXAMPLE 2 --------------------------**
```powershell
Get-NinjaOneDocumentTemplate -documentTemplateId 1
```

---

## Get-NinjaOneDocumentTemplates

**Synopsis**: Gets one or more document templates from the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **documentTemplateId** — The document template id to retrieve.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneDocumentTemplate
```

**-------------------------- EXAMPLE 2 --------------------------**
```powershell
Get-NinjaOneDocumentTemplate -documentTemplateId 1
```

---

## Get-NinjaOneGroupMembers

**Synopsis**: Gets group members from the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **groupId** — **(Required)** The group id to get members for.
* **refresh** — Refresh ?ToDo Query with Ninja

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneGroupMembers -groupId 1
```

---

## Get-NinjaOneGroups

**Synopsis**: Gets groups from the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **languageTag** — Group names should be returned in this language.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneGroups
```

---

## Get-NinjaOneInstaller

**Synopsis**: Gets agent installer URL from the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **organisationId** — **(Required)** The organisation id to get the installer for.
* **locationId** — **(Required)** The location id to get the installer for.
* **installerType** — **(Required)** Installer type/platform.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneInstaller -organisationId 1 -locationId 1 -installerType WINDOWS_MSI
```

**-------------------------- EXAMPLE 2 --------------------------**
```powershell
Get-NinjaOneInstaller -organisationId 1 -locationId 1 -installerType MAC_PKG
```

---

## Get-NinjaOneIntegrityCheckJobs

**Synopsis**: Gets backup integrity check jobs from the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **cursor** — Cursor name.
* **deletedDeviceFilter** — Deleted device filter.
* **deviceFilter** — Device filter.
* **include** — Which devices to include (defaults to 'active').
* **pageSize** — Number of results per page.
* **planType** — Filter by plan type. See the supplemental documentation at https://docs.homotechsual.dev/modules/ninjaone/filters/ptf
* **planTypeFilter** — Raw plan type filter. See the supplemental documentation at https://docs.homotechsual.dev/modules/ninjaone/filters/ptf
* **status** — Filter by status. See the supplemental documentation at https://docs.homotechsual.dev/modules/ninjaone/filters/sf
* **statusFilter** — Raw status filter. See the supplemental documentation at https://docs.homotechsual.dev/modules/ninjaone/filters/sf
* **startTimeBetween** — Start time between filter. See the supplemental documentation at https://docs.homotechsual.dev/modules/ninjaone/filters/stf
* **startTimeAfter** — Start time after filter. See the supplemental documentation at https://docs.homotechsual.dev/modules/ninjaone/filters/stf
* **startTimeFilter** — Raw start time filter. See the supplemental documentation at https://docs.homotechsual.dev/modules/ninjaone/filters/stf

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneIntegrityCheckJobs
```

**-------------------------- EXAMPLE 2 --------------------------**
```powershell
Get-NinjaOneIntegrityCheckJobs -status 'RUNNING'
```

**-------------------------- EXAMPLE 3 --------------------------**
```powershell
Get-NinjaOneIntegrityCheckJobs -status 'RUNNING', 'COMPLETED'
```

**-------------------------- EXAMPLE 4 --------------------------**
```powershell
Get-NinjaOneIntegrityCheckJobs -statusFilter 'status = RUNNING'
```

**-------------------------- EXAMPLE 5 --------------------------**
```powershell
Get-NinjaOneIntegrityCheckJobs -statusFilter 'status in (RUNNING, COMPLETED)'
```

**-------------------------- EXAMPLE 6 --------------------------**
```powershell
Get-NinjaOneIntegrityCheckJobs -planType 'IMAGE'
```

**-------------------------- EXAMPLE 7 --------------------------**
```powershell
Get-NinjaOneIntegrityCheckJobs -planType 'IMAGE', 'FILE_FOLDER'
```

**-------------------------- EXAMPLE 8 --------------------------**
```powershell
Get-NinjaOneIntegrityCheckJobs -planTypeFilter 'planType = IMAGE'
```

**-------------------------- EXAMPLE 9 --------------------------**
```powershell
Get-NinjaOneIntegrityCheckJobs -planTypeFilter 'planType in (IMAGE, FILE_FOLDER)'
```

**-------------------------- EXAMPLE 10 --------------------------**
```powershell
Get-NinjaOneIntegrityCheckJobs -startTimeBetween (Get-Date).AddDays(-1), (Get-Date)
```

**-------------------------- EXAMPLE 11 --------------------------**
```powershell
Get-NinjaOneIntegrityCheckJobs -startTimeAfter (Get-Date).AddDays(-1)
```

**-------------------------- EXAMPLE 12 --------------------------**
```powershell
Get-NinjaOneIntegrityCheckJobs -startTimeFilter 'startTime between(2024-01-01T00:00:00.000Z,2024-01-02T00:00:00.000Z)'
```

**-------------------------- EXAMPLE 13 --------------------------**
```powershell
Get-NinjaOneIntegrityCheckJobs -startTimeFilter 'startTime after 2024-01-01T00:00:00.000Z'
```

**-------------------------- EXAMPLE 14 --------------------------**
```powershell
Get-NinjaOneIntegrityCheckJobs -deviceFilter all
```

---

## Get-NinjaOneJobs

**Synopsis**: Gets jobs from the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **deviceId** — Filter by device id.
* **jobType** — Filter by job type.
* **deviceFilter** — Filter by device triggering the alert.
* **languageTag** — Filter by language tag.
* **timeZone** — Filter by timezone.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneJobs
```

**-------------------------- EXAMPLE 2 --------------------------**
```powershell
Get-NinjaOneJobs -jobType SOFTWARE_PATCH_MANAGEMENT
```

**-------------------------- EXAMPLE 3 --------------------------**
```powershell
Get-NinjaOneJobs -deviceFilter 'organization in (1,2,3)'
```

**-------------------------- EXAMPLE 4 --------------------------**
```powershell
Get-NinjaOneJobs -deviceId 1
```

---

## Get-NinjaOneKnowledgeBaseArticle

**Synopsis**: Gets a knowledge base article from the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **articleId** — **(Required)** The knowledge base article id to get.
* **signedUrls** — Get a map of content ids and their corresponding signed urls.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneKnowledgeBaseArticle -articleId 1
```

---

## Get-NinjaOneKnowledgeBaseFolder

**Synopsis**: Gets knowledge base folders from the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **folderId** — The knowledge base folder id to get.
* **folderPath** — The knowledge base folder path to get.
* **organisationId** — The organisation id to get knowledge base folders for.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneKnowledgeBaseFolders
```

**-------------------------- EXAMPLE 2 --------------------------**
```powershell
Get-NinjaOneKnowledgeBaseFolders -folderId 1
```

**-------------------------- EXAMPLE 3 --------------------------**
```powershell
Get-NinjaOneKnowledgeBaseFolders -folderPath 'Folder/Subfolder'
```

**-------------------------- EXAMPLE 4 --------------------------**
```powershell
Get-NinjaOneKnowledgeBaseFolders -organisationId 1
```

---

## Get-NinjaOneKnowledgeBaseFolders

**Synopsis**: Gets knowledge base folders from the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **folderId** — The knowledge base folder id to get.
* **folderPath** — The knowledge base folder path to get.
* **organisationId** — The organisation id to get knowledge base folders for.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneKnowledgeBaseFolders
```

**-------------------------- EXAMPLE 2 --------------------------**
```powershell
Get-NinjaOneKnowledgeBaseFolders -folderId 1
```

**-------------------------- EXAMPLE 3 --------------------------**
```powershell
Get-NinjaOneKnowledgeBaseFolders -folderPath 'Folder/Subfolder'
```

**-------------------------- EXAMPLE 4 --------------------------**
```powershell
Get-NinjaOneKnowledgeBaseFolders -organisationId 1
```

---

## Get-NinjaOneLastLoggedOnUsers

**Synopsis**: Gets the logged on users from the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **deviceFilter** — Filter devices.
* **cursor** — Cursor name.
* **pageSize** — Number of results per page.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneLoggedOnUsers
```

**-------------------------- EXAMPLE 2 --------------------------**
```powershell
Get-NinjaOneLoggedOnUsers -deviceFilter 'org = 1'
```

---

## Get-NinjaOneLocationBackupUsage

**Synopsis**: Gets backup usage for a location from the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **organisationId** — **(Required)** Organisation id to retrieve backup usage for.
* **locationId** — Location id to retrieve backup usage for.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneLocationBackupUsage -organisationId 1
```

**-------------------------- EXAMPLE 2 --------------------------**
```powershell
Get-NinjaOneLocationBackupUsage -organisationId 1 -locationId 1
```

---

## Get-NinjaOneLocationCustomFields

**Synopsis**: Gets location custom fields from the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **organisationId** — **(Required)** Filter by organisation id.
* **locationId** — **(Required)** Filter by location id.
* **withInheritance** — Inherit custom field values from parent organisation.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneLocationCustomFields organisationId 1 -locationId 2
```

**-------------------------- EXAMPLE 2 --------------------------**
```powershell
Get-NinjaOneLocationCustomFields organisationId 1 -locationId 2 -withInheritance
```

---

## Get-NinjaOneLocations

**Synopsis**: Gets locations from the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **pageSize** — Number of results per page.
* **after** — Start results from location id.
* **organisationId** — Filter by organisation id.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneLocations
```

**-------------------------- EXAMPLE 2 --------------------------**
```powershell
Get-NinjaOneLocations -after 1
```

**-------------------------- EXAMPLE 3 --------------------------**
```powershell
Get-NinjaOneLocations -organisationId 1
```

---

## Get-NinjaOneLoggedOnUsers

**Synopsis**: Gets the logged on users from the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **deviceFilter** — Filter devices.
* **cursor** — Cursor name.
* **pageSize** — Number of results per page.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneLoggedOnUsers
```

**-------------------------- EXAMPLE 2 --------------------------**
```powershell
Get-NinjaOneLoggedOnUsers -deviceFilter 'org = 1'
```

---

## Get-NinjaOneNetworkInterfaces

**Synopsis**: Gets the network interfaces from the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **deviceFilter** — Filter devices.
* **cursor** — Cursor name.
* **pageSize** — Number of results per page.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneNetworkInterfaces
```

**-------------------------- EXAMPLE 2 --------------------------**
```powershell
Get-NinjaOneNetworkInterfaces -deviceFilter 'org = 1'
```

---

## Get-NinjaOneNotificationChannel

**Synopsis**: Gets notification channels from the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **enabled** — Get all enabled notification channels.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneNotificationChannels
```

**-------------------------- EXAMPLE 2 --------------------------**
```powershell
Get-NinjaOneNotificationChannels -enabled
```

---

## Get-NinjaOneNotificationChannels

**Synopsis**: Gets notification channels from the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **enabled** — Get all enabled notification channels.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneNotificationChannels
```

**-------------------------- EXAMPLE 2 --------------------------**
```powershell
Get-NinjaOneNotificationChannels -enabled
```

---

## Get-NinjaOneOperatingSystems

**Synopsis**: Gets the operating systems from the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **deviceFilter** — Filter devices.
* **timeStamp** — Monitoring timestamp filter.
* **timeStampUnixEpoch** — Monitoring timestamp filter in unix time.
* **cursor** — Cursor name.
* **pageSize** — Number of results per page.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneOperatingSystems
```

**-------------------------- EXAMPLE 2 --------------------------**
```powershell
Get-NinjaOneOperatingSystems -deviceFilter 'org = 1'
```

**-------------------------- EXAMPLE 3 --------------------------**
```powershell
Get-NinjaOneOperatingSystems -timeStamp 1619712000
```

**-------------------------- EXAMPLE 4 --------------------------**
```powershell
Get-NinjaOneOperatingSystems | Group-Object -Property 'name'
```

---

## Get-NinjaOneOrganisation

**Synopsis**: Gets organisations from the NinjaOne API.

### Syntax
```powershell


```

### Parameters
* **organisationId** — Organisation id
* **after** — Start results from organisation id.
* **organisationFilter** — Filter results using an organisation filter string.
* **pageSize** — Number of results per page.
* **detailed** — Include locations and policy mappings.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneOrganisations
```

**-------------------------- EXAMPLE 2 --------------------------**
```powershell
Get-NinjaOneOrganisations -organisationId 1
```

**-------------------------- EXAMPLE 3 --------------------------**
```powershell
Get-NinjaOneOrganisations -pageSize 10 -after 1
```

**-------------------------- EXAMPLE 4 --------------------------**
```powershell
Get-NinjaOneOrganisations -detailed
```

---

## Get-NinjaOneOrganisationCustomFields

**Synopsis**: Gets organisation custom fields from the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **organisationId** — **(Required)** Filter by organisation id.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneOrganisationCustomFields -organisationId 1
```

---

## Get-NinjaOneOrganisationDocuments

**Synopsis**: Gets organisation documents from the NinjaOne API.

### Syntax
```powershell


```

### Parameters
* **organisationId** — **(Required)** Filter by organisation id.
* **documentName** — Filter by document name.
* **groupBy** — Group by template or organisation.
* **organisationIds** — Filter by organisation ids. Comma separated list of organisation ids.
* **templateIds** — Filter by template ids. Comma separated list of template ids.
* **templateName** — Filter by template name.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneOrganisationDocuments -organisationId 1
```

---

## Get-NinjaOneOrganisationDocumentSignedURLs

**Synopsis**: Gets organisation document signed URLs from the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **clientDocumentId** — **(Required)** The client document id to get signed URLs for.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneOrganisationDocumentSignedURLs -clientDocumentId 1
```

---

## Get-NinjaOneOrganisationInformation

**Synopsis**: Wrapper command using `Get-NinjaOneOrganisations` to get detailed information for an organisation.

### Syntax
```powershell

```

### Parameters
* **organisationId** — **(Required)** Filter by organisation id.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneOrganisationInformation -organisationId 1
```

---

## Get-NinjaOneOrganisationKnowledgeBaseArticles

**Synopsis**: Gets knowledge base articles for organisations from the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **articleName** — The knowledge base article name to get.
* **organisationIds** — The organisation ids to get knowledge base articles for. Use a comma separated list for multiple ids.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneOrganisationKnowledgeBaseArticles
```

**-------------------------- EXAMPLE 2 --------------------------**
```powershell
Get-NinjaOneOrganisationKnowledgeBaseArticles -articleName 'Article Name'
```

**-------------------------- EXAMPLE 3 --------------------------**
```powershell
Get-NinjaOneOrganisationKnowledgeBaseArticles -organisationIds '1,2,3'
```

---

## Get-NinjaOneOrganisationLocationBackupUsage

**Synopsis**: Gets backup usage for a location from the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **organisationId** — **(Required)** Organisation id to retrieve backup usage for.
* **locationId** — Location id to retrieve backup usage for.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneLocationBackupUsage -organisationId 1
```

**-------------------------- EXAMPLE 2 --------------------------**
```powershell
Get-NinjaOneLocationBackupUsage -organisationId 1 -locationId 1
```

---

## Get-NinjaOneOrganisationLocations

**Synopsis**: Wrapper command using `Get-NinjaOneLocations` to get locations for an organisation.

### Syntax
```powershell

```

### Parameters
* **organisationId** — **(Required)** Filter by organisation id.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneOrganisationLocations -organisationId 1
```

---

## Get-NinjaOneOrganisationLocationsBackupUsage

**Synopsis**: Wrapper command using `Get-NinjaOneLocationBackupUsage` to get backup usage for all locations in an organisation.

### Syntax
```powershell

```

### Parameters
* **organisationId** — **(Required)** Filter by organisation id.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneLocationBackupUsage -organisationId 1
```

---

## Get-NinjaOneOrganisations

**Synopsis**: Gets organisations from the NinjaOne API.

### Syntax
```powershell


```

### Parameters
* **organisationId** — Organisation id
* **after** — Start results from organisation id.
* **organisationFilter** — Filter results using an organisation filter string.
* **pageSize** — Number of results per page.
* **detailed** — Include locations and policy mappings.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneOrganisations
```

**-------------------------- EXAMPLE 2 --------------------------**
```powershell
Get-NinjaOneOrganisations -organisationId 1
```

**-------------------------- EXAMPLE 3 --------------------------**
```powershell
Get-NinjaOneOrganisations -pageSize 10 -after 1
```

**-------------------------- EXAMPLE 4 --------------------------**
```powershell
Get-NinjaOneOrganisations -detailed
```

---

## Get-NinjaOneOrganisationUsers

**Synopsis**: Wrapper command using `Get-NinjaOneUsers` to get users for an organisation.

### Syntax
```powershell

```

### Parameters
* **organisationId** — **(Required)** Filter by organisation id.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneOrganisationUsers -organisationId 1
```

---

## Get-NinjaOneOrganization

**Synopsis**: Gets organisations from the NinjaOne API.

### Syntax
```powershell


```

### Parameters
* **organisationId** — Organisation id
* **after** — Start results from organisation id.
* **organisationFilter** — Filter results using an organisation filter string.
* **pageSize** — Number of results per page.
* **detailed** — Include locations and policy mappings.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneOrganisations
```

**-------------------------- EXAMPLE 2 --------------------------**
```powershell
Get-NinjaOneOrganisations -organisationId 1
```

**-------------------------- EXAMPLE 3 --------------------------**
```powershell
Get-NinjaOneOrganisations -pageSize 10 -after 1
```

**-------------------------- EXAMPLE 4 --------------------------**
```powershell
Get-NinjaOneOrganisations -detailed
```

---

## Get-NinjaOneOrganizationCustomFields

**Synopsis**: Gets organisation custom fields from the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **organisationId** — **(Required)** Filter by organisation id.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneOrganisationCustomFields -organisationId 1
```

---

## Get-NinjaOneOrganizationDevices

**Synopsis**: Wrapper command using `Get-NinjaOneUsers` to get users for an organisation.

### Syntax
```powershell

```

### Parameters
* **organisationId** — **(Required)** Filter by organisation id.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneOrganisationUsers -organisationId 1
```

---

## Get-NinjaOneOrganizationDocuments

**Synopsis**: Gets organisation documents from the NinjaOne API.

### Syntax
```powershell


```

### Parameters
* **organisationId** — **(Required)** Filter by organisation id.
* **documentName** — Filter by document name.
* **groupBy** — Group by template or organisation.
* **organisationIds** — Filter by organisation ids. Comma separated list of organisation ids.
* **templateIds** — Filter by template ids. Comma separated list of template ids.
* **templateName** — Filter by template name.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneOrganisationDocuments -organisationId 1
```

---

## Get-NinjaOneOrganizationDocumentSignedURLs

**Synopsis**: Gets organisation document signed URLs from the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **clientDocumentId** — **(Required)** The client document id to get signed URLs for.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneOrganisationDocumentSignedURLs -clientDocumentId 1
```

---

## Get-NinjaOneOrganizationInformation

**Synopsis**: Wrapper command using `Get-NinjaOneOrganisations` to get detailed information for an organisation.

### Syntax
```powershell

```

### Parameters
* **organisationId** — **(Required)** Filter by organisation id.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneOrganisationInformation -organisationId 1
```

---

## Get-NinjaOneOrganizationKnowledgeBaseArticles

**Synopsis**: Gets knowledge base articles for organisations from the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **articleName** — The knowledge base article name to get.
* **organisationIds** — The organisation ids to get knowledge base articles for. Use a comma separated list for multiple ids.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneOrganisationKnowledgeBaseArticles
```

**-------------------------- EXAMPLE 2 --------------------------**
```powershell
Get-NinjaOneOrganisationKnowledgeBaseArticles -articleName 'Article Name'
```

**-------------------------- EXAMPLE 3 --------------------------**
```powershell
Get-NinjaOneOrganisationKnowledgeBaseArticles -organisationIds '1,2,3'
```

---

## Get-NinjaOneOrganizationLocationBackupUsage

**Synopsis**: Gets backup usage for a location from the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **organisationId** — **(Required)** Organisation id to retrieve backup usage for.
* **locationId** — Location id to retrieve backup usage for.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneLocationBackupUsage -organisationId 1
```

**-------------------------- EXAMPLE 2 --------------------------**
```powershell
Get-NinjaOneLocationBackupUsage -organisationId 1 -locationId 1
```

---

## Get-NinjaOneOrganizationLocations

**Synopsis**: Wrapper command using `Get-NinjaOneLocations` to get locations for an organisation.

### Syntax
```powershell

```

### Parameters
* **organisationId** — **(Required)** Filter by organisation id.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneOrganisationLocations -organisationId 1
```

---

## Get-NinjaOneOrganizationLocationsBackupUsage

**Synopsis**: Wrapper command using `Get-NinjaOneLocationBackupUsage` to get backup usage for all locations in an organisation.

### Syntax
```powershell

```

### Parameters
* **organisationId** — **(Required)** Filter by organisation id.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneLocationBackupUsage -organisationId 1
```

---

## Get-NinjaOneOrganizations

**Synopsis**: Gets organisations from the NinjaOne API.

### Syntax
```powershell


```

### Parameters
* **organisationId** — Organisation id
* **after** — Start results from organisation id.
* **organisationFilter** — Filter results using an organisation filter string.
* **pageSize** — Number of results per page.
* **detailed** — Include locations and policy mappings.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneOrganisations
```

**-------------------------- EXAMPLE 2 --------------------------**
```powershell
Get-NinjaOneOrganisations -organisationId 1
```

**-------------------------- EXAMPLE 3 --------------------------**
```powershell
Get-NinjaOneOrganisations -pageSize 10 -after 1
```

**-------------------------- EXAMPLE 4 --------------------------**
```powershell
Get-NinjaOneOrganisations -detailed
```

---

## Get-NinjaOneOrganizationUsers

**Synopsis**: Wrapper command using `Get-NinjaOneUsers` to get users for an organisation.

### Syntax
```powershell

```

### Parameters
* **organisationId** — **(Required)** Filter by organisation id.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneOrganisationUsers -organisationId 1
```

---

## Get-NinjaOneOSPatches

**Synopsis**: Gets the OS patches from the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **deviceFilter** — Filter devices.
* **timeStamp** — Monitoring timestamp filter.
* **timeStampUnixEpoch** — Monitoring timestamp filter in unix time.
* **status** — Filter patches by patch status.
* **type** — Filter patches by type.
* **severity** — Filter patches by severity.
* **cursor** — Cursor name.
* **pageSize** — Number of results per page.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneOSPatches
```

**-------------------------- EXAMPLE 2 --------------------------**
```powershell
Get-NinjaOneOSPatches -deviceFilter 'org = 1'
```

**-------------------------- EXAMPLE 3 --------------------------**
```powershell
Get-NinjaOneOSPatches -timeStamp 1619712000
```

**-------------------------- EXAMPLE 4 --------------------------**
```powershell
Get-NinjaOneOSPatches -status 'APPROVED'
```

**-------------------------- EXAMPLE 5 --------------------------**
```powershell
Get-NinjaOneOSPatches -type 'SECURITY_UPDATES'
```

**-------------------------- EXAMPLE 6 --------------------------**
```powershell
Get-NinjaOneOSPatches -severity 'CRITICAL'
```

---

## Get-NinjaOneOSPatchInstalls

**Synopsis**: Gets the OS patch installs from the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **deviceFilter** — Filter devices.
* **timeStamp** — Monitoring timestamp filter. PowerShell DateTime object.
* **timeStampUnixEpoch** — Monitoring timestamp filter. Unix Epoch time.
* **status** — Filter patches by patch status.
* **installedBefore** — Filter patches to those installed before this date.
* **installedBeforeUnixEpoch** — Filter patches to those installed after this date. Unix Epoch time.
* **installedAfter** — Filter patches to those installed after this date. PowerShell DateTime object.
* **installedAfterUnixEpoch** — Filter patches to those installed after this date. Unix Epoch time.
* **cursor** — Cursor name.
* **pageSize** — Number of results per page.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneOSPatchInstalls
```

**-------------------------- EXAMPLE 2 --------------------------**
```powershell
Get-NinjaOneOSPatchInstalls -deviceFilter 'org = 1'
```

**-------------------------- EXAMPLE 3 --------------------------**
```powershell
Get-NinjaOneOSPatchInstalls -timeStamp 1619712000
```

**-------------------------- EXAMPLE 4 --------------------------**
```powershell
Get-NinjaOneOSPatchInstalls -status 'FAILED'
```

**-------------------------- EXAMPLE 5 --------------------------**
```powershell
Get-NinjaOneOSPatchInstalls -installedBefore (Get-Date)
```

**-------------------------- EXAMPLE 6 --------------------------**
```powershell
Get-NinjaOneOSPatchInstalls -installedBeforeUnixEpoch 1619712000
```

**-------------------------- EXAMPLE 7 --------------------------**
```powershell
Get-NinjaOneOSPatchInstalls -installedAfter (Get-Date).AddDays(-1)
```

**-------------------------- EXAMPLE 8 --------------------------**
```powershell
Get-NinjaOneOSPatchInstalls -installedAfterUnixEpoch 1619712000
```

---

## Get-NinjaOnePolicies

**Synopsis**: Gets policies from the NinjaOne API.

### Syntax
```powershell

```

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOnePolicies
```

---

## Get-NinjaOnePolicyOverrides

**Synopsis**: Gets the policy overrides by device from the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **cursor** — Cursor name.
* **deviceFilter** — Device filter.
* **pageSize** — Number of results per page.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOnePolicyOverrides
```

**-------------------------- EXAMPLE 2 --------------------------**
```powershell
Get-NinjaOnePolicyOverrides -deviceFilter 'org = 1'
```

---

## Get-NinjaOneProcessors

**Synopsis**: Gets the processors from the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **deviceFilter** — Filter devices.
* **timeStamp** — Monitoring timestamp filter. PowerShell DateTime object.
* **timeStampUnixEpoch** — Monitoring timestamp filter. Unix Epoch time.
* **cursor** — Cursor name.
* **pageSize** — Number of results per page.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneProcessors
```

**-------------------------- EXAMPLE 2 --------------------------**
```powershell
Get-NinjaOneProcessors -deviceFilter 'org = 1'
```

**-------------------------- EXAMPLE 3 --------------------------**
```powershell
Get-NinjaOneProcessors -timeStamp 1619712000
```

---

## Get-NinjaOneRAIDControllers

**Synopsis**: Gets the RAID controllers from the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **deviceFilter** — Filter devices.
* **timeStamp** — Monitoring timestamp filter. PowerShell DateTime object.
* **timeStampUnixEpoch** — Monitoring timestamp filter. Unix Epoch time.
* **cursor** — Cursor name.
* **pageSize** — Number of results per page.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneRAIDControllers
```

**-------------------------- EXAMPLE 2 --------------------------**
```powershell
Get-NinjaOneRAIDControllers -deviceFilter 'org = 1'
```

**-------------------------- EXAMPLE 3 --------------------------**
```powershell
Get-NinjaOneRAIDControllers -timeStamp 1619712000
```

---

## Get-NinjaOneRAIDDrives

**Synopsis**: Gets the RAID drives from the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **deviceFilter** — Filter devices.
* **timeStamp** — Monitoring timestamp filter. PowerShell DateTime object.
* **timeStampUnixEpoch** — Monitoring timestamp filter. Unix Epoch time.
* **cursor** — Cursor name.
* **pageSize** — Number of results per page.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneRAIDDrives
```

**-------------------------- EXAMPLE 2 --------------------------**
```powershell
Get-NinjaOneRAIDDrives -deviceFilter 'org = 1'
```

**-------------------------- EXAMPLE 3 --------------------------**
```powershell
Get-NinjaOneRAIDDrives -timeStamp 1619712000
```

---

## Get-NinjaOneRelatedItemAttachment

**Synopsis**: Gets a related item attachment from the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **relatedItemId** — **(Required)** The related item id to get the attachment for.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneKnowledgeBaseArticle -articleId 1
```

---

## Get-NinjaOneRelatedItemAttachmentSignedURLs

**Synopsis**: Gets related item attachment signed URLs from the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **entityType** — **(Required)** The entity type of the related item.
* **entityId** — **(Required)** The entity id of the related item.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneRelatedItemAttachmentSignedURLs -entityType 'KB_DOCUMENT' -entityId 1
```

---

## Get-NinjaOneRelatedItems

**Synopsis**: Gets items related to an entity or entity type from the NinjaOne API.

### Syntax
```powershell



```

### Parameters
* **all** — **(Required)** Return all related items.
* **relatedTo** — **(Required)** Find items related to the given entity type/id.
* **relatedFrom** — **(Required)** Find items with related entities of the given type/id.
* **entityType** — **(Required)** The entity type to get related items for.
* **entityId** — The entity id to get related items for.
* **scope** — The scope of the related items.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneRelatedItems -all
```

**-------------------------- EXAMPLE 2 --------------------------**
```powershell
Get-NinjaOneRelatedItems -relatedTo -entityType 'organization'
```

**-------------------------- EXAMPLE 3 --------------------------**
```powershell
Get-NinjaOneRelatedItems -relatedTo -entityType 'organization' -entityId 1
```

**-------------------------- EXAMPLE 4 --------------------------**
```powershell
Get-NinjaOneRelatedItems -relatedFrom -entityType 'organization'
```

**-------------------------- EXAMPLE 5 --------------------------**
```powershell
Get-NinjaOneRelatedItems -relatedFrom -entityType 'organization' -entityId 1
```

---

## Get-NinjaOneRole

**Synopsis**: Gets device roles from the NinjaOne API.

### Syntax
```powershell

```

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneRoles
```

---

## Get-NinjaOneRoles

**Synopsis**: Gets device roles from the NinjaOne API.

### Syntax
```powershell

```

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneRoles
```

---

## Get-NinjaOneSoftwareInventory

**Synopsis**: Gets the software inventory from the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **deviceFilter** — Filter devices.
* **cursor** — Cursor name.
* **pageSize** — Number of results per page.
* **installedBefore** — Filter software to those installed before this date. PowerShell DateTime object.
* **installedBeforeUnixEpoch** — Filter software to those installed after this date. Unix Epoch time.
* **installedAfter** — Filter software to those installed after this date. PowerShell DateTime object.
* **installedAfterUnixEpoch** — Filter software to those installed after this date. Unix Epoch time.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneSoftwareInventory
```

**-------------------------- EXAMPLE 2 --------------------------**
```powershell
Get-NinjaOneSoftwareInventory -deviceFilter 'org = 1'
```

**-------------------------- EXAMPLE 3 --------------------------**
```powershell
Get-NinjaOneSoftwareInventory -installedBefore (Get-Date)
```

**-------------------------- EXAMPLE 4 --------------------------**
```powershell
Get-NinjaOneSoftwareInventory -installedBeforeUnixEpoch 1619712000
```

**-------------------------- EXAMPLE 5 --------------------------**
```powershell
Get-NinjaOneSoftwareInventory -installedAfter (Get-Date).AddDays(-1)
```

**-------------------------- EXAMPLE 6 --------------------------**
```powershell
Get-NinjaOneSoftwareInventory -installedAfterUnixEpoch 1619712000
```

---

## Get-NinjaOneSoftwarePatches

**Synopsis**: Gets the software patches from the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **deviceFilter** — Filter devices.
* **timeStamp** — Monitoring timestamp filter. PowerShell DateTime object.
* **timeStampUnixEpoch** — Monitoring timestamp filter. Unix Epoch time.
* **status** — Filter patches by patch status.
* **productIdentifier** — Filter patches by product identifier.
* **type** — Filter patches by type.
* **impact** — Filter patches by impact.
* **cursor** — Cursor name.
* **pageSize** — Number of results per page.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneSoftwarePatches
```

**-------------------------- EXAMPLE 2 --------------------------**
```powershell
Get-NinjaOneSoftwarePatches -deviceFilter 'org = 1'
```

**-------------------------- EXAMPLE 3 --------------------------**
```powershell
Get-NinjaOneSoftwarePatches -timeStamp 1619712000
```

**-------------------------- EXAMPLE 4 --------------------------**
```powershell
Get-NinjaOneSoftwarePatches -status 'FAILED'
```

**-------------------------- EXAMPLE 5 --------------------------**
```powershell
Get-NinjaOneSoftwarePatches -productIdentifier 23e4567-e89b-12d3-a456-426614174000
```

**-------------------------- EXAMPLE 6 --------------------------**
```powershell
Get-NinjaOneSoftwarePatches -type 'PATCH'
```

**-------------------------- EXAMPLE 7 --------------------------**
```powershell
Get-NinjaOneSoftwarePatches -impact 'OPTIONAL'
```

---

## Get-NinjaOneSoftwarePatchInstalls

**Synopsis**: Gets the software patch installs from the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **deviceFilter** — Filter devices.
* **timeStamp** — Monitoring timestamp filter. PowerShell DateTime object.
* **timeStampUnixEpoch** — Monitoring timestamp filter. Unix Epoch time.
* **type** — Filter patches by patch status.
* **impact** — Filter patches by impact.
* **status** — Filter patches by patch status.
* **productIdentifier** — Filter patches by product identifier.
* **installedBefore** — Filter patches to those installed before this date. PowerShell DateTime object.
* **installedBeforeUnixEpoch** — Filter patches to those installed after this date. Unix Epoch time.
* **installedAfter** — Filter patches to those installed after this date. PowerShell DateTime object.
* **installedAfterUnixEpoch** — Filter patches to those installed after this date. Unix Epoch time.
* **cursor** — Cursor name.
* **pageSize** — Number of results per page.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneSoftwarePatchInstalls
```

**-------------------------- EXAMPLE 2 --------------------------**
```powershell
Get-NinjaOneSoftwarePatchInstalls -deviceFilter 'org = 1'
```

**-------------------------- EXAMPLE 3 --------------------------**
```powershell
Get-NinjaOneSoftwarePatchInstalls -timeStamp 1619712000
```

**-------------------------- EXAMPLE 4 --------------------------**
```powershell
Get-NinjaOneSoftwarePatchInstalls -type 'PATCH'
```

**-------------------------- EXAMPLE 5 --------------------------**
```powershell
Get-NinjaOneSoftwarePatchInstalls -impact 'OPTIONAL'
```

**-------------------------- EXAMPLE 6 --------------------------**
```powershell
Get-NinjaOneSoftwarePatchInstalls -status 'FAILED'
```

**-------------------------- EXAMPLE 7 --------------------------**
```powershell
Get-NinjaOneSoftwarePatchInstalls -productIdentifier 23e4567-e89b-12d3-a456-426614174000
```

**-------------------------- EXAMPLE 8 --------------------------**
```powershell
Get-NinjaOneSoftwarePatchInstalls -installedBefore (Get-Date)
```

**-------------------------- EXAMPLE 9 --------------------------**
```powershell
Get-NinjaOneSoftwarePatchInstalls -installedBeforeUnixEpoch 1619712000
```

**-------------------------- EXAMPLE 10 --------------------------**
```powershell
Get-NinjaOneSoftwarePatchInstalls -installedAfter (Get-Date)
```

**-------------------------- EXAMPLE 11 --------------------------**
```powershell
Get-NinjaOneSoftwarePatchInstalls -installedAfterUnixEpoch 1619712000
```

---

## Get-NinjaOneSoftwareProducts

**Synopsis**: Gets software products from the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **deviceId** — The device id to get software products for.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneSoftwareProducts
```

**-------------------------- EXAMPLE 2 --------------------------**
```powershell
Get-NinjaOneSoftwareProducts -deviceId 1
```

---

## Get-NinjaOneTasks

**Synopsis**: Gets tasks from the NinjaOne API.

### Syntax
```powershell

```

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneTasks
```

---

## Get-NinjaOneTicketAttributes

**Synopsis**: Gets ticket attributes from the NinjaOne API.

### Syntax
```powershell

```

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneTicketAttributes
```

---

## Get-NinjaOneTicketBoards

**Synopsis**: Gets boards from the NinjaOne API.

### Syntax
```powershell

```

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneTicketBoards
```

---

## Get-NinjaOneTicketForms

**Synopsis**: Gets ticket forms from the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **ticketFormId** — Ticket form id.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneTicketForms
```

**-------------------------- EXAMPLE 2 --------------------------**
```powershell
Get-NinjaOneTicketForms -ticketFormId 1
```

---

## Get-NinjaOneTicketingUsers

**Synopsis**: Gets lists of users from the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **anchorNaturalId** — Start results from this user natural id.
* **clientId** — Get users for this organisation id.
* **pageSize** — The number of results to return.
* **searchCriteria** — The search criteria to apply to the request.
* **userType** — Filter by user type. This can be one of "TECHNICIAN", "END_USER" or "CONTACT".

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneTicketingUsers
```

**-------------------------- EXAMPLE 2 --------------------------**
```powershell
Get-NinjaOneTicketingUsers -anchorNaturalId 10
```

**-------------------------- EXAMPLE 3 --------------------------**
```powershell
Get-NinjaOneTicketingUsers -clientId 1
```

**-------------------------- EXAMPLE 4 --------------------------**
```powershell
Get-NinjaOneTicketingUsers -pageSize 10
```

**-------------------------- EXAMPLE 5 --------------------------**
```powershell
Get-NinjaOneTicketingUsers -searchCriteria 'mikey@homotechsual.dev'
```

**-------------------------- EXAMPLE 6 --------------------------**
```powershell
Get-NinjaOneTicketingUsers -userType TECHNICIAN
```

---

## Get-NinjaOneTicketLogEntries

**Synopsis**: Gets ticket log entries from the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **ticketId** — **(Required)** Filter by ticket id.
* **createTime** — Filter by create time.
* **pageSize** — The number of results to return.
* **type** — Filter log entries by type.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneTicketLogEntries -ticketId 1
```

**-------------------------- EXAMPLE 2 --------------------------**
```powershell
Get-NinjaOneTicketLogEntries -ticketId 1 -type DESCRIPTION
```

---

## Get-NinjaOneTickets

**Synopsis**: Gets tickets from the NinjaOne API.

### Syntax
```powershell


```

### Parameters
* **ticketId** — **(Required)** The ticket id to get.
* **boardId** — **(Required)** The board id to get tickets for.
* **sort** — The sort rules to apply to the request. Create these using `[NinjaOneTicketBoardSort]::new()`.
* **filters** — Any filters to apply to the request. Create these using `[NinjaOneTicketBoardFilter]::new()`.
* **lastCursorId** — The last cursor id to use for the request.
* **pageSize** — The number of results to return.
* **searchCriteria** — The search criteria to apply to the request.
* **includeColumns** — Inclue the given columns in the response.
* **includeMetadata** — Include the metadata in the response.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneTickets -ticketId 1
```

**-------------------------- EXAMPLE 2 --------------------------**
```powershell
Get-NinjaOneTickets -boardId 1
```

**-------------------------- EXAMPLE 3 --------------------------**
```powershell
Get-NinjaOneTickets -boardId 1 -filters @{status = 'open'}
```

---

## Get-NinjaOneTicketStatuses

**Synopsis**: Gets ticket statuses from the NinjaOne API.

### Syntax
```powershell

```

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneTicketStatuses
```

---

## Get-NinjaOneUsers

**Synopsis**: Gets users from the NinjaOne API.

### Syntax
```powershell


```

### Parameters
* **organisationId** — **(Required)** Get users for this organisation id.
* **userType** — Filter by user type. This can be one of "TECHNICIAN" or "END_USER".
* **includeRoles** — Include roles in the response.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneUsers
```

**-------------------------- EXAMPLE 2 --------------------------**
```powershell
Get-NinjaOneUsers -includeRoles
```

**-------------------------- EXAMPLE 3 --------------------------**
```powershell
Get-NinjaOneUsers -userType TECHNICIAN
```

**-------------------------- EXAMPLE 4 --------------------------**
```powershell
Get-NinjaOneUsers -organisationId 1
```

---

## Get-NinjaOneVolumes

**Synopsis**: Gets the volumes from the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **deviceFilter** — Filter devices.
* **timeStamp** — Monitoring timestamp filter. PowerShell DateTime object.
* **timeStampUnixEpoch** — Monitoring timestamp filter. Unix Epoch time.
* **cursor** — Cursor name.
* **pageSize** — Number of results per page.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneVolumes
```

**-------------------------- EXAMPLE 2 --------------------------**
```powershell
Get-NinjaOneVolumes -deviceFilter 'org = 1'
```

**-------------------------- EXAMPLE 3 --------------------------**
```powershell
Get-NinjaOneVolumes -timeStamp 1619712000
```

---

## Get-NinjaOneWindowsEventPolicyCondition

**Synopsis**: Gets detailed information on a single windows event condition for a given policy from the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **policyId** — **(Required)** The policy id to get the windows event conditions for.
* **conditionId** — **(Required)** The condition id to get the windows event condition for.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneWindowsEventPolicyCondition -policyId 1 -conditionId 1
```

---

## Get-NinjaOneWindowsServices

**Synopsis**: Gets the windows services from the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **deviceFilter** — Filter devices.
* **name** — Filter by service name.
* **state** — Filter by service state.
* **cursor** — Cursor name.
* **pageSize** — Number of results per page.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Get-NinjaOneWindowsServices
```

**-------------------------- EXAMPLE 2 --------------------------**
```powershell
Get-NinjaOneWindowsServices -deviceFilter 'organization in (1,2,3)'
```

**-------------------------- EXAMPLE 3 --------------------------**
```powershell
Get-NinjaOneWindowsServices -name 'NinjaOne'
```

**-------------------------- EXAMPLE 4 --------------------------**
```powershell
Get-NinjaOneWindowsServices -state 'RUNNING'
```

---

## Invoke-NinjaOneDeviceScript

**Synopsis**: Runs a script or built-in action against the given device.

### Syntax
```powershell


```

### Parameters
* **deviceId** — **(Required)** The device to run a script on.
* **type** — **(Required)** The type - script or action.
* **scriptId** — **(Required)** The id of the script to run. Only used if the type is script.
* **actionUId** — **(Required)** The unique uid of the action to run. Only used if the type is action.
* **parameters** — The parameters to pass to the script or action.
* **runAs** — The credential/role identifier to use when running the script.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Invoke-NinjaOneDeviceScript -deviceId 1 -type 'SCRIPT' -scriptId 1
```

**-------------------------- EXAMPLE 2 --------------------------**
```powershell
Invoke-NinjaOneDeviceScript -deviceId 1 -type 'ACTION' -actionUId '00000000-0000-0000-0000-000000000000'
```

**-------------------------- EXAMPLE 3 --------------------------**
```powershell

```

---

## Invoke-NinjaOneRequest

**Synopsis**: Sends a request to the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **Method** — **(Required)** HTTP method to use.
* **Uri** — **(Required)** The URI to send the request to.
* **Body** — The body of the request.
* **Raw** — Return the raw response - don't convert from JSON.

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Invoke-NinjaOneRequest -Method 'GET' -Uri 'https://eu.ninjarmm.com/v2/activities'
```

---

## Invoke-NinjaOneWindowsServiceAction

**Synopsis**: Runs an action against the given Windows Service for the given device.

### Syntax
```powershell

```

### Parameters
* **deviceId** — **(Required)** The device(s) to change service configuration for.
* **serviceId** — **(Required)** The service to alter configuration for.
* **action** — **(Required)** The action to invoke.
* **WhatIf** — N/A
* **Confirm** — N/A

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell

```

---

## New-NinjaOneAttachmentRelation

**Synopsis**: Creates a new attachment relation using the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **entityType** — **(Required)** The entity type to create the attachment relation for.
* **entityId** — **(Required)** The entity id to create the attachment relation for.
* **attachmentRelation** — The attachment relation data.
* **show** — Show the attachment relation that was created.
* **WhatIf** — N/A
* **Confirm** — N/A

---

## New-NinjaOneCustomFieldObject

**Synopsis**: Create a new Custom Field object.

### Syntax
```powershell

```

### Parameters
* **Name** — **(Required)** The custom field name.
* **Value** — **(Required)** The custom field value.
* **IsHTML** — Is the custom field value HTML.

---

## New-NinjaOneCustomFieldsPolicyCondition

**Synopsis**: Creates a new custom fields policy condition using the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **policyId** — **(Required)** The policy id to create the custom fields policy condition for.
* **customFieldsPolicyCondition** — **(Required)** An object containing the custom fields policy condition to create.
* **show** — Show the custom fields policy condition that was created.
* **WhatIf** — N/A
* **Confirm** — N/A

---

## New-NinjaOneDocumentTemplate

**Synopsis**: Creates a new document template using the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **name** — **(Required)** The name of the document template.
* **description** — The description of the document template.
* **allowMultiple** — Allow multiple instances of this document template to be used per organisation.
* **mandatory** — Is this document template mandatory for all organisations.
* **fields** — **(Required)** The document template fields.
* **availableToAllTechnicians** — Make this template available to all technicians.
* **allowedTechnicianRoles** — Set the technician roles that can access this template.
* **show** — Show the document template that was created.
* **WhatIf** — N/A
* **Confirm** — N/A

---

## New-NinjaOneDocumentTemplateFieldObject

**Synopsis**: Create a new Document Template Field object.

### Syntax
```powershell


```

### Parameters
* **Label** — **(Required)** The human readable label for the field.
* **Name** — **(Required)** The machine readable name for the field. This is an immutable value.
* **Description** — The description of the field.
* **Type** — **(Required)** The type of the field.
* **TechnicianPermission** — The technician permissions for the field.
* **ScriptPermission** — The script permissions for the field.
* **APIPermission** — The API permissions for the field.
* **DefaultValue** — The default value for the field.
* **Options** — The field options (a.k.a the field content).
* **ElementName** — **(Required)** When creating a UI element (e.g a title, separator or description box) this is the machine readable name of the UI element.
* **ElementValue** — When creating a UI element (e.g a title, separator or description box) this is the value of the UI element.
* **ElementType** — **(Required)** When creating a UI element (e.g a title, separator or description box) this is the type of the UI element.

---

## New-NinjaOneEntityRelation

**Synopsis**: Creates a new entity relation using the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **entityType** — **(Required)** The entity type to create the entity relation for.
* **entityId** — **(Required)** The entity id to create the entity relation for.
* **relatedEntityType** — **(Required)** The entity type to relate to.
* **relatedEntityId** — **(Required)** The entity id to relate to.
* **show** — Show the entity relation that was created.
* **WhatIf** — N/A
* **Confirm** — N/A

---

## New-NinjaOneEntityRelationObject

**Synopsis**: Create a new Entity Relation object.

### Syntax
```powershell

```

### Parameters
* **Entity** — The entity type of the relation.
* **relationEntityType** — N/A
* **Operator** — N/A
* **Value** — N/A

---

## New-NinjaOneEntityRelations

**Synopsis**: Creates multiple new entity relations using the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **entityType** — **(Required)** The entity type to create the entity relation for.
* **entityId** — **(Required)** The entity id to create the entity relation for.
* **entityRelations** — **(Required)** The entity relations to create.
* **show** — Show the entity relation that was created.
* **WhatIf** — N/A
* **Confirm** — N/A

---

## New-NinjaOneInstaller

**Synopsis**: Creates a new installer using the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **organisationId** — **(Required)** The organization id to use when creating the installer.
* **locationId** — **(Required)** The location id to use when creating the installer.
* **installerType** — **(Required)** The installer type to use when creating the installer.
* **nodeRoleId** — The number of uses permitted for the installer.
[Parameter(Position = 3, ValueFromPipelineByPropertyName)]
[Int]$usageLimit,
The node role id to use when creating the installer.
* **WhatIf** — N/A
* **Confirm** — N/A

---

## New-NinjaOneIntegrityCheckJob

**Synopsis**: Creates a new backup integrity check job using the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **deviceId** — **(Required)** The deviceId to create the integrity check job for.
* **planUid** — **(Required)** The planUid to create the integrity check job for.
* **show** — Show the integrity check job that was created.
* **WhatIf** — N/A
* **Confirm** — N/A

---

## New-NinjaOneLocation

**Synopsis**: Creates a new location using the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **organisationId** — **(Required)** The organization Id to use when creating the location.
* **location** — **(Required)** An object containing the location to create.
* **show** — Show the location that was created.
* **WhatIf** — N/A
* **Confirm** — N/A

---

## New-NinjaOneOrganisation

**Synopsis**: Creates a new organisation using the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **templateOrganisationId** — The Id of the organisation to use as a template.
* **organisation** — **(Required)** An object containing the organisation to create.
* **show** — Show the organisation that was created.
* **WhatIf** — N/A
* **Confirm** — N/A

---

## New-NinjaOneOrganisationDocument

**Synopsis**: Creates a new organisation document using the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **organisationId** — **(Required)** The Id of the organisation to create the document for.
* **documentTemplateId** — **(Required)** The Id of the document template to use.
* **organisationDocument** — **(Required)** An object containing an array of organisation documents to create.
* **show** — Show the organisation document that was created.
* **WhatIf** — N/A
* **Confirm** — N/A

---

## New-NinjaOneOrganisationDocuments

**Synopsis**: Creates new organisation documents using the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **organisationDocuments** — **(Required)** An object containing an array of organisation documents to create.
* **show** — Show the organisation documents that were created.
* **WhatIf** — N/A
* **Confirm** — N/A

---

## New-NinjaOneOrganization

**Synopsis**: Creates a new organisation using the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **templateOrganisationId** — The Id of the organisation to use as a template.
* **organisation** — **(Required)** An object containing the organisation to create.
* **show** — Show the organisation that was created.
* **WhatIf** — N/A
* **Confirm** — N/A

---

## New-NinjaOneOrganizationDocument

**Synopsis**: Creates new organisation documents using the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **organisationDocuments** — **(Required)** An object containing an array of organisation documents to create.
* **show** — Show the organisation documents that were created.
* **WhatIf** — N/A
* **Confirm** — N/A

---

## New-NinjaOnePolicy

**Synopsis**: Creates a new policy using the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **mode** — **(Required)** The mode to run in, new, child or copy.
* **policy** — **(Required)** An object containing the policy to create.
* **templatePolicyId** — The Id of the template policy to copy from.
* **show** — Show the policy that was created.
* **WhatIf** — N/A
* **Confirm** — N/A

---

## New-NinjaOneSecureRelation

**Synopsis**: Creates a new secure value relation using the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **entityType** — **(Required)** The entity type to create the secre relation for.
* **entityId** — **(Required)** The entity id to create the secucre relation for.
* **secureValueName** — **(Required)** The name of the secure value.
* **secureValueURL** — The URL for the secure value.
* **secureValueNotes** — Notes to accompany the secure value.
* **secureValueUsername** — The username for the secure value.
* **secureValuePassword** — The password for the secure value.
* **show** — Show the secure relation that was created.
* **WhatIf** — N/A
* **Confirm** — N/A

---

## New-NinjaOneTicket

**Synopsis**: Creates a new ticket using the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **ticket** — **(Required)** An object containing the ticket to create.
* **show** — Show the ticket that was created.
* **WhatIf** — N/A
* **Confirm** — N/A

---

## New-NinjaOneTicketComment

**Synopsis**: Creates a new ticket comment using the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **ticketId** — **(Required)** The ticket Id to use when creating the ticket comment.
* **comment** — **(Required)** An object containing the ticket comment to create.
* **show** — Show the ticket comment that was created.
* **WhatIf** — N/A
* **Confirm** — N/A

---

## New-NinjaOneWindowsEventPolicyCondition

**Synopsis**: Creates a new windows event policy condition using the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **policyId** — **(Required)** The policy id to create the windows event policy condition for.
* **windowsEventPolicyCondition** — **(Required)** An object containing the windows event policy condition to create.
* **show** — Show the windows event policy condition that was created.
* **WhatIf** — N/A
* **Confirm** — N/A

---

## Remove-NinjaOneDeviceMaintenance

**Synopsis**: Cancels scheduled maintenance for the given device.

### Syntax
```powershell

```

### Parameters
* **deviceId** — **(Required)** The device Id to cancel maintenance for.
* **WhatIf** — N/A
* **Confirm** — N/A

---

## Remove-NinjaOneDocumentTemplate

**Synopsis**: Removes a document template using the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **documentTemplateId** — **(Required)** The document template to delete.
* **WhatIf** — N/A
* **Confirm** — N/A

---

## Remove-NinjaOneOrganisationDocument

**Synopsis**: Removes an organisation document using the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **clientDocumentId** — **(Required)** The organisation document to delete.
* **WhatIf** — N/A
* **Confirm** — N/A

---

## Remove-NinjaOneOrganizationDocument

**Synopsis**: Removes an organisation document using the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **clientDocumentId** — **(Required)** The organisation document to delete.
* **WhatIf** — N/A
* **Confirm** — N/A

---

## Remove-NinjaOnePolicyCondition

**Synopsis**: Remove the given policy condition.

### Syntax
```powershell

```

### Parameters
* **policyId** — **(Required)** The policy id to remove the condition from.
* **conditionId** — **(Required)** The condition id to remove.
* **WhatIf** — N/A
* **Confirm** — N/A

---

## Remove-NinjaOneRelatedItem

**Synopsis**: Removes the given item relationship.

### Syntax
```powershell

```

### Parameters
* **relatedItemId** — **(Required)** The related item id to remove.
* **WhatIf** — N/A
* **Confirm** — N/A

---

## Remove-NinjaOneRelatedItems

**Synopsis**: Removes the item relationships for the given entity type and entity id.

### Syntax
```powershell

```

### Parameters
* **entityType** — **(Required)** The entity type to remove related items for.
* **entityId** — **(Required)** The entity id to remove related items for.
* **WhatIf** — N/A
* **Confirm** — N/A

---

## Remove-NinjaOneWebhook

**Synopsis**: Removes webhook configuration for the current application/API client.

### Syntax
```powershell

```

### Parameters
* **WhatIf** — N/A
* **Confirm** — N/A

---

## Reset-NinjaOneAlert

**Synopsis**: Resets alerts using the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **uid** — **(Required)** The alert Id to reset status for.
* **activityData** — The reset activity data.
* **WhatIf** — N/A
* **Confirm** — N/A

---

## Reset-NinjaOneDevicePolicyOverrides

**Synopsis**: Resets (removes) device policy overrides using the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **deviceId** — **(Required)** The device Id to reset policy overrides for.
* **WhatIf** — N/A
* **Confirm** — N/A

---

## Restart-NinjaOneDevice

**Synopsis**: Reboots a device using the NinjaOne API.

### Syntax
```powershell

```

### Parameters
* **deviceId** — **(Required)** The device Id to reset status for.
* **mode** — **(Required)** The reboot mode.
* **reason** — The reboot reason.
* **WhatIf** — N/A
* **Confirm** — N/A

---

## Set-NinjaOneDevice

**Synopsis**: Sets device information, like friendly name, user data etc.

### Syntax
```powershell

```

### Parameters
* **deviceId** — **(Required)** The device to set the information for.
* **deviceInformation** — **(Required)** The device information body object.
* **WhatIf** — N/A
* **Confirm** — N/A

---

## Set-NinjaOneDeviceApproval

**Synopsis**: Sets the approval status of the specified device(s)

### Syntax
```powershell

```

### Parameters
* **mode** — **(Required)** The approval mode.
* **deviceIds** — **(Required)** The device(s) to set the approval status for.
* **WhatIf** — N/A
* **Confirm** — N/A

---

## Set-NinjaOneDeviceCustomFields

**Synopsis**: Sets the value of the specified device custom fields.

### Syntax
```powershell

```

### Parameters
* **deviceId** — **(Required)** The device to set the custom field value(s) for.
* **deviceCustomFields** — **(Required)** The custom field(s) body object.
* **WhatIf** — N/A
* **Confirm** — N/A

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Set-NinjaOneDeviceCustomFields -deviceId 1 -customFields @{ CustomField1 = 'Value1'; CustomField2 = 'Value2' }
```

---

## Set-NinjaOneDeviceMaintenance

**Synopsis**: Sets a new maintenance window for the specified device(s)

### Syntax
```powershell

```

### Parameters
* **deviceId** — **(Required)** The device to set a maintenance window for.
* **disabledFeatures** — **(Required)** The features to disable during maintenance.
* **start** — The start date/time for the maintenance window - PowerShell DateTime object.
* **unixStart** — The start date/time for the maintenance window - Unix Epoch time.
* **end** — The end date/time for the maintenance window - PowerShell DateTime object.
* **unixEnd** — The end date/time for the maintenance window - Unix Epoch time.
* **WhatIf** — N/A
* **Confirm** — N/A

---

## Set-NinjaOneDocumentTemplate

**Synopsis**: Sets a document template.

### Syntax
```powershell

```

### Parameters
* **documentTemplateId** — **(Required)** The document template id to update.
* **name** — The name of the document template.
* **description** — The description of the document template.
* **allowMultiple** — Allow multiple instances of this document template to be used per organisation.
* **mandatory** — Is this document template mandatory for all organisations.
* **fields** — **(Required)** The document template fields.
* **availableToAllTechnicians** — Make this template available to all technicians.
* **allowedTechnicianRoles** — Set the technician roles that can access this template.
* **show** — Show the document template that was created.
* **WhatIf** — N/A
* **Confirm** — N/A

---

## Set-NinjaOneLocation

**Synopsis**: Sets location information, like name, address, description etc.

### Syntax
```powershell

```

### Parameters
* **organisationId** — **(Required)** The organisation to set the location information for.
* **locationId** — **(Required)** The location to set the information for.
* **locationInformation** — **(Required)** The location information body object.
* **WhatIf** — N/A
* **Confirm** — N/A

---

## Set-NinjaOneLocationCustomFields

**Synopsis**: Sets an location's custom fields.

### Syntax
```powershell

```

### Parameters
* **organisationId** — **(Required)** The organisation to set the custom fields for.
* **locationId** — **(Required)** The location to set the custom fields for.
* **locationCustomFields** — **(Required)** The organisation custom field body object.
* **WhatIf** — N/A
* **Confirm** — N/A

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
$LocationCustomFields = @{
```

---

## Set-NinjaOneNodeRolePolicyAssignment

**Synopsis**: Sets policy assignment for node role(s) for an organisation.

### Syntax
```powershell


```

### Parameters
* **organisationId** — **(Required)** The organisation to update the policy assignment for.
* **nodeRoleId** — **(Required)** The node role id to update the policy assignment for.
* **policyId** — **(Required)** The policy id to assign to the node role.
* **policyAssignments** — **(Required)** The node role policy assignments to update. Should be an array of objects with the following properties: nodeRoleId, policyId.
* **WhatIf** — N/A
* **Confirm** — N/A

---

## Set-NinjaOneOrganisation

**Synopsis**: Sets organisation information, like name, node approval mode etc.

### Syntax
```powershell

```

### Parameters
* **organisationId** — **(Required)** The organisation to set the information for.
* **organisationInformation** — **(Required)** The organisation information body object.
* **WhatIf** — N/A
* **Confirm** — N/A

---

## Set-NinjaOneOrganisationCustomFields

**Synopsis**: Updates an organisation's custom fields.

### Syntax
```powershell

```

### Parameters
* **organisationId** — **(Required)** The organisation to set the custom fields for.
* **organisationCustomFields** — **(Required)** The organisation custom field body object.
* **WhatIf** — N/A
* **Confirm** — N/A

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
$OrganisationCustomFields = @{
```

---

## Set-NinjaOneOrganisationDocument

**Synopsis**: Sets an organisation document.

### Syntax
```powershell

```

### Parameters
* **organisationId** — **(Required)** The organisation to set the information for.
* **clientDocumentId** — **(Required)** The organisation document id to update.
* **organisationDocument** — **(Required)** The organisation information body object.
* **WhatIf** — N/A
* **Confirm** — N/A

---

## Set-NinjaOneOrganisationDocuments

**Synopsis**: Sets one or more organisation documents.

### Syntax
```powershell

```

### Parameters
* **organisationDocuments** — **(Required)** The organisation documents to update.
* **WhatIf** — N/A
* **Confirm** — N/A

---

## Set-NinjaOneOrganisationPolicies

**Synopsis**: Sets policy assignment for node role(s) for an organisation.

### Syntax
```powershell


```

### Parameters
* **organisationId** — **(Required)** The organisation to update the policy assignment for.
* **nodeRoleId** — **(Required)** The node role id to update the policy assignment for.
* **policyId** — **(Required)** The policy id to assign to the node role.
* **policyAssignments** — **(Required)** The node role policy assignments to update. Should be an array of objects with the following properties: nodeRoleId, policyId.
* **WhatIf** — N/A
* **Confirm** — N/A

---

## Set-NinjaOneOrganisationPolicyMapping

**Synopsis**: Sets policy assignment for node role(s) for an organisation.

### Syntax
```powershell


```

### Parameters
* **organisationId** — **(Required)** The organisation to update the policy assignment for.
* **nodeRoleId** — **(Required)** The node role id to update the policy assignment for.
* **policyId** — **(Required)** The policy id to assign to the node role.
* **policyAssignments** — **(Required)** The node role policy assignments to update. Should be an array of objects with the following properties: nodeRoleId, policyId.
* **WhatIf** — N/A
* **Confirm** — N/A

---

## Set-NinjaOneOrganisationPolicyMappings

**Synopsis**: Sets policy assignment for node role(s) for an organisation.

### Syntax
```powershell


```

### Parameters
* **organisationId** — **(Required)** The organisation to update the policy assignment for.
* **nodeRoleId** — **(Required)** The node role id to update the policy assignment for.
* **policyId** — **(Required)** The policy id to assign to the node role.
* **policyAssignments** — **(Required)** The node role policy assignments to update. Should be an array of objects with the following properties: nodeRoleId, policyId.
* **WhatIf** — N/A
* **Confirm** — N/A

---

## Set-NinjaOneOrganization

**Synopsis**: Sets organisation information, like name, node approval mode etc.

### Syntax
```powershell

```

### Parameters
* **organisationId** — **(Required)** The organisation to set the information for.
* **organisationInformation** — **(Required)** The organisation information body object.
* **WhatIf** — N/A
* **Confirm** — N/A

---

## Set-NinjaOneOrganizationCustomFields

**Synopsis**: Updates an organisation's custom fields.

### Syntax
```powershell

```

### Parameters
* **organisationId** — **(Required)** The organisation to set the custom fields for.
* **organisationCustomFields** — **(Required)** The organisation custom field body object.
* **WhatIf** — N/A
* **Confirm** — N/A

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
$OrganisationCustomFields = @{
```

---

## Set-NinjaOneOrganizationDocument

**Synopsis**: Sets an organisation document.

### Syntax
```powershell

```

### Parameters
* **organisationId** — **(Required)** The organisation to set the information for.
* **clientDocumentId** — **(Required)** The organisation document id to update.
* **organisationDocument** — **(Required)** The organisation information body object.
* **WhatIf** — N/A
* **Confirm** — N/A

---

## Set-NinjaOneOrganizationDocuments

**Synopsis**: Sets one or more organisation documents.

### Syntax
```powershell

```

### Parameters
* **organisationDocuments** — **(Required)** The organisation documents to update.
* **WhatIf** — N/A
* **Confirm** — N/A

---

## Set-NinjaOneOrganizationPolicies

**Synopsis**: Sets policy assignment for node role(s) for an organisation.

### Syntax
```powershell


```

### Parameters
* **organisationId** — **(Required)** The organisation to update the policy assignment for.
* **nodeRoleId** — **(Required)** The node role id to update the policy assignment for.
* **policyId** — **(Required)** The policy id to assign to the node role.
* **policyAssignments** — **(Required)** The node role policy assignments to update. Should be an array of objects with the following properties: nodeRoleId, policyId.
* **WhatIf** — N/A
* **Confirm** — N/A

---

## Set-NinjaOneOrganizationPolicyMapping

**Synopsis**: Sets policy assignment for node role(s) for an organisation.

### Syntax
```powershell


```

### Parameters
* **organisationId** — **(Required)** The organisation to update the policy assignment for.
* **nodeRoleId** — **(Required)** The node role id to update the policy assignment for.
* **policyId** — **(Required)** The policy id to assign to the node role.
* **policyAssignments** — **(Required)** The node role policy assignments to update. Should be an array of objects with the following properties: nodeRoleId, policyId.
* **WhatIf** — N/A
* **Confirm** — N/A

---

## Set-NinjaOneOrganizationPolicyMappings

**Synopsis**: Sets policy assignment for node role(s) for an organisation.

### Syntax
```powershell


```

### Parameters
* **organisationId** — **(Required)** The organisation to update the policy assignment for.
* **nodeRoleId** — **(Required)** The node role id to update the policy assignment for.
* **policyId** — **(Required)** The policy id to assign to the node role.
* **policyAssignments** — **(Required)** The node role policy assignments to update. Should be an array of objects with the following properties: nodeRoleId, policyId.
* **WhatIf** — N/A
* **Confirm** — N/A

---

## Set-NinjaOneTicket

**Synopsis**: Sets a ticket.

### Syntax
```powershell

```

### Parameters
* **ticketId** — **(Required)** The ticket Id.
* **ticket** — **(Required)** The ticket object.
* **WhatIf** — N/A
* **Confirm** — N/A

---

## Set-NinjaOneWebhook

**Synopsis**: Update webhook configuration for the current application/API client.

### Syntax
```powershell

```

### Parameters
* **webhookConfiguration** — **(Required)** The webhook configuration object.
* **WhatIf** — N/A
* **Confirm** — N/A

---

## Set-NinjaOneWindowsServiceConfiguration

**Synopsis**: Sets the configuration of the given Windows Service for the given device.

### Syntax
```powershell

```

### Parameters
* **deviceId** — **(Required)** The device to change servce configuration for.
* **serviceId** — **(Required)** The service to alter configuration for.
* **configuration** — **(Required)** The configuration to set.
* **WhatIf** — N/A
* **Confirm** — N/A

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Set-NinjaOneWindowsServiceConfiguration -deviceId "12345" -serviceId "NinjaRMMAgent" -Configuration @{ startType = "AUTO_START"; userName = "LocalSystem" }
```

---

## Update-NinjaOneDevice

**Synopsis**: Sets device information, like friendly name, user data etc.

### Syntax
```powershell

```

### Parameters
* **deviceId** — **(Required)** The device to set the information for.
* **deviceInformation** — **(Required)** The device information body object.
* **WhatIf** — N/A
* **Confirm** — N/A

---

## Update-NinjaOneDeviceApproval

**Synopsis**: Sets the approval status of the specified device(s)

### Syntax
```powershell

```

### Parameters
* **mode** — **(Required)** The approval mode.
* **deviceIds** — **(Required)** The device(s) to set the approval status for.
* **WhatIf** — N/A
* **Confirm** — N/A

---

## Update-NinjaOneDeviceCustomFields

**Synopsis**: Sets the value of the specified device custom fields.

### Syntax
```powershell

```

### Parameters
* **deviceId** — **(Required)** The device to set the custom field value(s) for.
* **deviceCustomFields** — **(Required)** The custom field(s) body object.
* **WhatIf** — N/A
* **Confirm** — N/A

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Set-NinjaOneDeviceCustomFields -deviceId 1 -customFields @{ CustomField1 = 'Value1'; CustomField2 = 'Value2' }
```

---

## Update-NinjaOneDeviceMaintenance

**Synopsis**: Sets a new maintenance window for the specified device(s)

### Syntax
```powershell

```

### Parameters
* **deviceId** — **(Required)** The device to set a maintenance window for.
* **disabledFeatures** — **(Required)** The features to disable during maintenance.
* **start** — The start date/time for the maintenance window - PowerShell DateTime object.
* **unixStart** — The start date/time for the maintenance window - Unix Epoch time.
* **end** — The end date/time for the maintenance window - PowerShell DateTime object.
* **unixEnd** — The end date/time for the maintenance window - Unix Epoch time.
* **WhatIf** — N/A
* **Confirm** — N/A

---

## Update-NinjaOneDocumentTemplate

**Synopsis**: Sets a document template.

### Syntax
```powershell

```

### Parameters
* **documentTemplateId** — **(Required)** The document template id to update.
* **name** — The name of the document template.
* **description** — The description of the document template.
* **allowMultiple** — Allow multiple instances of this document template to be used per organisation.
* **mandatory** — Is this document template mandatory for all organisations.
* **fields** — **(Required)** The document template fields.
* **availableToAllTechnicians** — Make this template available to all technicians.
* **allowedTechnicianRoles** — Set the technician roles that can access this template.
* **show** — Show the document template that was created.
* **WhatIf** — N/A
* **Confirm** — N/A

---

## Update-NinjaOneLocation

**Synopsis**: Sets location information, like name, address, description etc.

### Syntax
```powershell

```

### Parameters
* **organisationId** — **(Required)** The organisation to set the location information for.
* **locationId** — **(Required)** The location to set the information for.
* **locationInformation** — **(Required)** The location information body object.
* **WhatIf** — N/A
* **Confirm** — N/A

---

## Update-NinjaOneLocationCustomFields

**Synopsis**: Sets an location's custom fields.

### Syntax
```powershell

```

### Parameters
* **organisationId** — **(Required)** The organisation to set the custom fields for.
* **locationId** — **(Required)** The location to set the custom fields for.
* **locationCustomFields** — **(Required)** The organisation custom field body object.
* **WhatIf** — N/A
* **Confirm** — N/A

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
$LocationCustomFields = @{
```

---

## Update-NinjaOneNodeRolePolicyAssignment

**Synopsis**: Sets policy assignment for node role(s) for an organisation.

### Syntax
```powershell


```

### Parameters
* **organisationId** — **(Required)** The organisation to update the policy assignment for.
* **nodeRoleId** — **(Required)** The node role id to update the policy assignment for.
* **policyId** — **(Required)** The policy id to assign to the node role.
* **policyAssignments** — **(Required)** The node role policy assignments to update. Should be an array of objects with the following properties: nodeRoleId, policyId.
* **WhatIf** — N/A
* **Confirm** — N/A

---

## Update-NinjaOneOrganisation

**Synopsis**: Sets organisation information, like name, node approval mode etc.

### Syntax
```powershell

```

### Parameters
* **organisationId** — **(Required)** The organisation to set the information for.
* **organisationInformation** — **(Required)** The organisation information body object.
* **WhatIf** — N/A
* **Confirm** — N/A

---

## Update-NinjaOneOrganisationCustomFields

**Synopsis**: Updates an organisation's custom fields.

### Syntax
```powershell

```

### Parameters
* **organisationId** — **(Required)** The organisation to set the custom fields for.
* **organisationCustomFields** — **(Required)** The organisation custom field body object.
* **WhatIf** — N/A
* **Confirm** — N/A

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
$OrganisationCustomFields = @{
```

---

## Update-NinjaOneOrganisationDocument

**Synopsis**: Sets an organisation document.

### Syntax
```powershell

```

### Parameters
* **organisationId** — **(Required)** The organisation to set the information for.
* **clientDocumentId** — **(Required)** The organisation document id to update.
* **organisationDocument** — **(Required)** The organisation information body object.
* **WhatIf** — N/A
* **Confirm** — N/A

---

## Update-NinjaOneOrganisationDocuments

**Synopsis**: Sets one or more organisation documents.

### Syntax
```powershell

```

### Parameters
* **organisationDocuments** — **(Required)** The organisation documents to update.
* **WhatIf** — N/A
* **Confirm** — N/A

---

## Update-NinjaOneOrganisationPolicyMapping

**Synopsis**: Sets policy assignment for node role(s) for an organisation.

### Syntax
```powershell


```

### Parameters
* **organisationId** — **(Required)** The organisation to update the policy assignment for.
* **nodeRoleId** — **(Required)** The node role id to update the policy assignment for.
* **policyId** — **(Required)** The policy id to assign to the node role.
* **policyAssignments** — **(Required)** The node role policy assignments to update. Should be an array of objects with the following properties: nodeRoleId, policyId.
* **WhatIf** — N/A
* **Confirm** — N/A

---

## Update-NinjaOneOrganisationPolicyMappings

**Synopsis**: Sets policy assignment for node role(s) for an organisation.

### Syntax
```powershell


```

### Parameters
* **organisationId** — **(Required)** The organisation to update the policy assignment for.
* **nodeRoleId** — **(Required)** The node role id to update the policy assignment for.
* **policyId** — **(Required)** The policy id to assign to the node role.
* **policyAssignments** — **(Required)** The node role policy assignments to update. Should be an array of objects with the following properties: nodeRoleId, policyId.
* **WhatIf** — N/A
* **Confirm** — N/A

---

## Update-NinjaOneOrganization

**Synopsis**: Sets organisation information, like name, node approval mode etc.

### Syntax
```powershell

```

### Parameters
* **organisationId** — **(Required)** The organisation to set the information for.
* **organisationInformation** — **(Required)** The organisation information body object.
* **WhatIf** — N/A
* **Confirm** — N/A

---

## Update-NinjaOneOrganizationCustomFields

**Synopsis**: Updates an organisation's custom fields.

### Syntax
```powershell

```

### Parameters
* **organisationId** — **(Required)** The organisation to set the custom fields for.
* **organisationCustomFields** — **(Required)** The organisation custom field body object.
* **WhatIf** — N/A
* **Confirm** — N/A

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
$OrganisationCustomFields = @{
```

---

## Update-NinjaOneOrganizationDocument

**Synopsis**: Sets an organisation document.

### Syntax
```powershell

```

### Parameters
* **organisationId** — **(Required)** The organisation to set the information for.
* **clientDocumentId** — **(Required)** The organisation document id to update.
* **organisationDocument** — **(Required)** The organisation information body object.
* **WhatIf** — N/A
* **Confirm** — N/A

---

## Update-NinjaOneOrganizationDocuments

**Synopsis**: Sets one or more organisation documents.

### Syntax
```powershell

```

### Parameters
* **organisationDocuments** — **(Required)** The organisation documents to update.
* **WhatIf** — N/A
* **Confirm** — N/A

---

## Update-NinjaOneOrganizationPolicyMapping

**Synopsis**: Sets policy assignment for node role(s) for an organisation.

### Syntax
```powershell


```

### Parameters
* **organisationId** — **(Required)** The organisation to update the policy assignment for.
* **nodeRoleId** — **(Required)** The node role id to update the policy assignment for.
* **policyId** — **(Required)** The policy id to assign to the node role.
* **policyAssignments** — **(Required)** The node role policy assignments to update. Should be an array of objects with the following properties: nodeRoleId, policyId.
* **WhatIf** — N/A
* **Confirm** — N/A

---

## Update-NinjaOneOrganizationPolicyMappings

**Synopsis**: Sets policy assignment for node role(s) for an organisation.

### Syntax
```powershell


```

### Parameters
* **organisationId** — **(Required)** The organisation to update the policy assignment for.
* **nodeRoleId** — **(Required)** The node role id to update the policy assignment for.
* **policyId** — **(Required)** The policy id to assign to the node role.
* **policyAssignments** — **(Required)** The node role policy assignments to update. Should be an array of objects with the following properties: nodeRoleId, policyId.
* **WhatIf** — N/A
* **Confirm** — N/A

---

## Update-NinjaOneTicket

**Synopsis**: Sets a ticket.

### Syntax
```powershell

```

### Parameters
* **ticketId** — **(Required)** The ticket Id.
* **ticket** — **(Required)** The ticket object.
* **WhatIf** — N/A
* **Confirm** — N/A

---

## Update-NinjaOneWebhook

**Synopsis**: Update webhook configuration for the current application/API client.

### Syntax
```powershell

```

### Parameters
* **webhookConfiguration** — **(Required)** The webhook configuration object.
* **WhatIf** — N/A
* **Confirm** — N/A

---

## Update-NinjaOneWindowsServiceConfiguration

**Synopsis**: Sets the configuration of the given Windows Service for the given device.

### Syntax
```powershell

```

### Parameters
* **deviceId** — **(Required)** The device to change servce configuration for.
* **serviceId** — **(Required)** The service to alter configuration for.
* **configuration** — **(Required)** The configuration to set.
* **WhatIf** — N/A
* **Confirm** — N/A

### Examples
**-------------------------- EXAMPLE 1 --------------------------**
```powershell
Set-NinjaOneWindowsServiceConfiguration -deviceId "12345" -serviceId "NinjaRMMAgent" -Configuration @{ startType = "AUTO_START"; userName = "LocalSystem" }
```

---


