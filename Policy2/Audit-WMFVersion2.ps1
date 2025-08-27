Configuration AuditWMFVersion2
{
    Import-DscResource -ModuleName PSDscResources

    Node localhost
    {
        Script CheckWMF {
            GetScript  = '@{ Result = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\PowerShell\3\PowerShellEngine").PowerShellVersion }'
            TestScript = '[version](Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\PowerShell\3\PowerShellEngine").PowerShellVersion -ge [version]"5.1"'
            SetScript  = 'return $true'
        }
    }
}

AuditWMFVersion2
