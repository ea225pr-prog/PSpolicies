# File: Audit_PSDirect_Disabled.ps1
# Compliant if PowerShell Direct service (vmicvmsession) is Disabled or not present.
Configuration Audit_PSDirect_Disabled {
  Import-DscResource -ModuleName PSDscResources

  Node 'localhost' {
    Script CheckPSDirect {
      GetScript = @'
$svc = Get-CimInstance -ClassName Win32_Service -Filter "Name='vmicvmsession'" -ErrorAction SilentlyContinue
if(-not $svc){ $res = "NotPresent" } else { $res = "State=$($svc.State);StartMode=$($svc.StartMode)" }
@{ Result = $res }
'@
      TestScript = @'
$svc = Get-CimInstance -ClassName Win32_Service -Filter "Name='vmicvmsession'" -ErrorAction SilentlyContinue
if(-not $svc){ return $true }   # No service => PS Direct unavailable => compliant
return ($svc.StartMode -eq "Disabled")
'@
      SetScript = 'return $true'  # audit-only
    }
  }
}
Audit_PSDirect_Disabled