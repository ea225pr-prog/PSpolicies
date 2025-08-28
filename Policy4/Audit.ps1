# File: AuditPSv2_Disabled.ps1
Configuration AuditPSv2_Disabled {
  Import-DscResource -ModuleName PSDscResources

  Node 'localhost' {
    Script CheckPSv2 {
      GetScript = @'
$features = "MicrosoftWindowsPowerShellV2","MicrosoftWindowsPowerShellV2Root"
$result = foreach($f in $features){
  $g = Get-WindowsOptionalFeature -Online -FeatureName $f -ErrorAction SilentlyContinue
  [pscustomobject]@{ Feature=$f; State = ($(if($g){$g.State}else{"NotPresent"})) }
}
@{ Result = $result }
'@
      TestScript = @'
$features = "MicrosoftWindowsPowerShellV2","MicrosoftWindowsPowerShellV2Root"
$bad = @("Enabled","EnablePending")
$states = foreach($f in $features){
  $g = Get-WindowsOptionalFeature -Online -FeatureName $f -ErrorAction SilentlyContinue
  if($g){ $g.State } else { "NotPresent" }
}
$noncompliant = $states | Where-Object { $_ -in $bad }
if ($noncompliant.Count -gt 0) { return $false } else { return $true }
'@
      SetScript = 'return $true'   # audit-only
    }
  }
}

AuditPSv2_Disabled
