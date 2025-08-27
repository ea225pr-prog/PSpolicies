Configuration AuditWMFVersion
{
    Import-DscResource -ModuleName PSDscResources

    Node localhost
    {
        Script CheckWMFVersion
        {
            GetScript = {
                $wmfVersion = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\PowerShell\3\PowerShellEngine").PowerShellVersion
                @{
                    Result = $wmfVersion
                    Ensure = "Present"
                }
            }
            TestScript = {
                $wmfVersion = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\PowerShell\3\PowerShellEngine").PowerShellVersion
                $targetVersion = [version]"5.1"
                return $wmfVersion -ge $targetVersion
            }
            SetScript = {
                # No set needed for audit
            }
        }
    }
}

AuditWMFVersion
