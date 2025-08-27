# File: WMF5_Audit.ps1
Configuration WMF5_Audit {
    param([Version]$MinVersion = '5.1.0')
    Import-DscResource -ModuleName PSDscResources
    Node 'localhost' {
        Script CheckWMF {
            GetScript  = @'
$k1="HKLM:\SOFTWARE\Microsoft\PowerShell\3\PowerShellEngine"
$k2="HKLM:\SOFTWARE\WOW6432Node\Microsoft\PowerShell\3\PowerShellEngine"
$ver = (Get-ItemProperty -Path $k1 -Name PowerShellVersion -EA SilentlyContinue).PowerShellVersion
if(-not $ver){ $ver = (Get-ItemProperty -Path $k2 -Name PowerShellVersion -EA SilentlyContinue).PowerShellVersion }
if(-not $ver){ $ver = $PSVersionTable.PSVersion.ToString() }
@{ Result = $ver }
'@
            TestScript = @"
$k1="HKLM:\SOFTWARE\Microsoft\PowerShell\3\PowerShellEngine"
$k2="HKLM:\SOFTWARE\WOW6432Node\Microsoft\PowerShell\3\PowerShellEngine"
\$ver = (Get-ItemProperty -Path \$k1 -Name PowerShellVersion -EA SilentlyContinue).PowerShellVersion
if(-not \$ver){ \$ver = (Get-ItemProperty -Path \$k2 -Name PowerShellVersion -EA SilentlyContinue).PowerShellVersion }
if(-not \$ver){ \$ver = \$PSVersionTable.PSVersion.ToString() }
return ([version]\$ver -ge [version]'$MinVersion')
"@
            SetScript  = 'return $true' # audit-only
        }
    }
}

WMF5_Audit
