Configuration Audit_WinRM_KerberosOnly {
  Import-DscResource -ModuleName PSDscResources
  Node 'localhost' {
    Script CheckWinRMAuth {
      GetScript  = @'
function Get-Auth($n){
  try { (Get-Item "WSMan:\localhost\Service\Auth\$n" -ErrorAction Stop).Value }
  catch {
    try {
      $l = winrm get winrm/config/service/auth | Where-Object { $_ -match "^\s*$n\s*=" }
      if($l){ ($l -split '=',2)[1].Trim() } else { $null }
    } catch { $null }
  }
}
$vals = [ordered]@{
  Basic       = Get-Auth 'Basic'
  Digest      = Get-Auth 'Digest'
  Kerberos    = Get-Auth 'Kerberos'
  Negotiate   = Get-Auth 'Negotiate'
  Certificate = Get-Auth 'Certificate'
  CredSSP     = Get-Auth 'CredSSP'
}
@{ Result = ($vals.GetEnumerator() | ForEach-Object { "$($_.Key)=$($_.Value)" } -join '; ') }
'@
      TestScript = @'
function ToBool($v){ if($v -is [bool]){return $v}; if($null -eq $v){return $false}; return ($v.ToString().Trim().ToLower() -eq 'true') }
function Get-Auth($n){
  try { (Get-Item "WSMan:\localhost\Service\Auth\$n" -ErrorAction Stop).Value }
  catch {
    try {
      $l = winrm get winrm/config/service/auth | Where-Object { $_ -match "^\s*$n\s*=" }
      if($l){ ($l -split '=',2)[1].Trim() } else { $null }
    } catch { $null }
  }
}
$Basic       = ToBool (Get-Auth 'Basic')
$Digest      = ToBool (Get-Auth 'Digest')
$Kerberos    = ToBool (Get-Auth 'Kerberos')
$Negotiate   = ToBool (Get-Auth 'Negotiate')
$Certificate = ToBool (Get-Auth 'Certificate')
$CredSSP     = ToBool (Get-Auth 'CredSSP')

return (-not $Basic -and -not $Digest -and $Kerberos -and -not $Negotiate -and -not $Certificate -and -not $CredSSP)
'@
      SetScript  = 'return $true'
    }
  }
}
Audit_WinRM_KerberosOnly
