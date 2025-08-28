# File: Audit_ExecutionPolicy_RemoteSigned.ps1
# Audits that HKLM ExecutionPolicy == 'RemoteSigned' (compliant if true)
Configuration Audit_ExecutionPolicy_RemoteSigned {
  Import-DscResource -ModuleName PSDscResources

  Node 'localhost' {
    Script ExecPolicyCheck {
      GetScript = @'
$p = "HKLM:\SOFTWARE\Microsoft\PowerShell\1\ShellIds\Microsoft.PowerShell"
$val = (Get-ItemProperty -Path $p -Name ExecutionPolicy -ErrorAction SilentlyContinue).ExecutionPolicy
@{ Result = $val }
'@
      TestScript = @'
$p = "HKLM:\SOFTWARE\Microsoft\PowerShell\1\ShellIds\Microsoft.PowerShell"
$val = (Get-ItemProperty -Path $p -Name ExecutionPolicy -ErrorAction SilentlyContinue).ExecutionPolicy
return [string]::Equals($val, "RemoteSigned", [System.StringComparison]::OrdinalIgnoreCase)
'@
      SetScript = 'return $true'  # audit-only
    }
  }
}

Audit_ExecutionPolicy_RemoteSigned