# File: Audit_ScriptBlockLogging_Enabled.ps1
# Compliant if EnableScriptBlockLogging == 1 (policy path)
Configuration Audit_ScriptBlockLogging_Enabled {
  Import-DscResource -ModuleName PSDscResources
  Node 'localhost' {
    Script CheckSBL {
      GetScript = @'
$path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging"
$val  = (Get-ItemProperty -Path $path -Name EnableScriptBlockLogging -ErrorAction SilentlyContinue).EnableScriptBlockLogging
@{ Result = $(if($null -eq $val) { "NotConfigured" } else { "EnableScriptBlockLogging=$val" }) }
'@
      TestScript = @'
$path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging"
$val  = (Get-ItemProperty -Path $path -Name EnableScriptBlockLogging -ErrorAction SilentlyContinue).EnableScriptBlockLogging
return ([int]$val -eq 1)
'@
      SetScript = 'return $true'  # audit-only
    }
  }
}

Audit_ScriptBlockLogging_Enabled