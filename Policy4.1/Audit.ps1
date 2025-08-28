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
$state = if ($g) { $g.State.Trim().ToLower() } else { "notpresent" }
return ($state -ne "enabled" -and $state -ne "enablepending")
'@

            SetScript = 'return $true'  # audit-only
        }
    }
}

AuditPSv2_Disabled
