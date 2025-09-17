Configuration Audit_WinRM_KrbPlusNegotiate_WinRM_v3 {
  Import-DscResource -ModuleName PSDscResources
  Node 'localhost' {
    Script CheckWinRMAuth {
      GetScript = @'
function Get-WinRMAuthMap {
  $w = "$env:windir\System32\winrm.cmd"
  if(-not (Test-Path $w) -and (Test-Path "$env:windir\sysnative\winrm.cmd")){ $w = "$env:windir\sysnative\winrm.cmd" }
  $out = & cmd.exe /c "`"$w`" get winrm/config/service/auth" 2>$null
  $m = @{}; foreach($line in $out){
    if($line -match "^\s*(Basic|Kerberos|Negotiate|Certificate|CredSSP)\s*=\s*(\S+)"){ $m[$matches[1]] = $matches[2].ToLower() }
  }; return $m
}
$m = Get-WinRMAuthMap
$sb = New-Object System.Text.StringBuilder
foreach($k in 'Basic','Kerberos','Negotiate','Certificate','CredSSP'){ if($m.ContainsKey($k)){ [void]$sb.Append("$k=$($m[$k]); ") } }
@{ Result = "MARK: Krb+Neg v3; " + $sb.ToString().TrimEnd(' ',';') }
'@
      TestScript = @'
function Get-WinRMAuthMap {
  $w = "$env:windir\System32\winrm.cmd"
  if(-not (Test-Path $w) -and (Test-Path "$env:windir\sysnative\winrm.cmd")){ $w = "$env:windir\sysnative\winrm.cmd" }
  $out = & cmd.exe /c "`"$w`" get winrm/config/service/auth" 2>$null
  $m = @{}; foreach($line in $out){
    if($line -match "^\s*(Basic|Kerberos|Negotiate|Certificate|CredSSP)\s*=\s*(\S+)"){ $m[$matches[1]] = $matches[2].ToLower() }
  }; return $m
}
$need = @{ Basic='false'; Kerberos='true'; Negotiate='true'; Certificate='false'; CredSSP='false' }
$m = Get-WinRMAuthMap
$ok = $true; foreach($k in $need.Keys){ if(-not $m.ContainsKey($k) -or $m[$k] -ne $need[$k]){ $ok=$false } }
return [bool]$ok
'@
      SetScript = 'return $true'
    }
  }
}
Audit_WinRM_KrbPlusNegotiate_WinRM_v3
