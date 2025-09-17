Configuration Audit_WinRM_KrbPlusNegotiate_WinRM {
  Import-DscResource -ModuleName PSDscResources
  Node 'localhost' {
    Script CheckWinRMAuth {
      GetScript = @'
function Get-WinRMAuthMap {
  $out = & cmd.exe /c "%windir%\System32\winrm.cmd get winrm/config/service/auth" 2>$null
  $m = @{}
  foreach($line in $out){
    if($line -match "^\s*(Basic|Kerberos|Negotiate|Certificate|CredSSP)\s*=\s*(\S+)"){
      $m[$matches[1]] = $matches[2].ToLower()
    }
  }
  return $m
}
$m = Get-WinRMAuthMap
@{ Result = ($m.GetEnumerator() | ForEach-Object { "$($_.Key)=$($_.Value)" } -join '; ') }
'@
      TestScript = @'
function Get-WinRMAuthMap {
  $out = & cmd.exe /c "%windir%\System32\winrm.cmd get winrm/config/service/auth" 2>$null
  $m = @{}
  foreach($line in $out){
    if($line -match "^\s*(Basic|Kerberos|Negotiate|Certificate|CredSSP)\s*=\s*(\S+)"){
      $m[$matches[1]] = $matches[2].ToLower()
    }
  }
  return $m
}
$need = @{
  Basic       = 'false'
  Kerberos    = 'true'
  Negotiate   = 'true'
  Certificate = 'false'
  CredSSP     = 'false'
}
$m = Get-WinRMAuthMap
$ok = $true
foreach($k in $need.Keys){
  if(-not $m.ContainsKey($k) -or $m[$k] -ne $need[$k]){ $ok = $false }
}
return $ok
'@
      SetScript = 'return $true'
    }
  }
}
Audit_WinRM_KrbPlusNegotiate_WinRM
