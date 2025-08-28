Configuration Audit_PSTranscription_Enabled {
    Import-DscResource -ModuleName PSDscResources

    Node 'localhost' {
        Script CheckTranscription {
            GetScript = @'
$path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\Transcription"
$props = Get-ItemProperty -Path $path -ErrorAction SilentlyContinue
$enabled = $props.EnableTranscripting
@{ Result = ("Enabled={0}" -f $enabled) }
'@
            TestScript = @'
$path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\Transcription"
try {
    $val = (Get-ItemProperty -Path $path -Name EnableTranscripting -ErrorAction SilentlyContinue).EnableTranscripting
    if ($null -eq $val) { return $false }
    return ([int]$val -eq 1)
} catch {
    return $false
}
'@
            SetScript = 'return $true'  # audit-only
        }
    }
}

Audit_PSTranscription_Enabled
