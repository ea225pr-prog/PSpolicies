Configuration AuditPSv2_Disabled {
    Import-DscResource -ModuleName PSDscResources

    Node 'localhost' {
        Script CheckPSv2 {
            GetScript = @'
$feature = "MicrosoftWindowsPowerShellV2"
$g = Get-WindowsOptionalFeature -Online -FeatureName $feature -ErrorAction SilentlyContinue
$res = if ($g) { "State=$($g.State)" } else { "NotPresent" }
@{ Result = $res }
'@

            TestScript = @'
$g = Get-WindowsOptionalFeature -Online -FeatureName "MicrosoftWindowsPowerShellV2" -ErrorAction SilentlyContinue
if (-not $g) { return $true } # Not present means compliant
$state = [string]$g.State
$state = $state.Trim().ToLower()
return ($state -eq "disabled")
'@

            SetScript = 'return $true'  # audit-only, no remediation
        }
    }
}

AuditPSv2_Disabled
