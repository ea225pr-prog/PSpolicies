# File: Audit_PSTranscription_Enabled.ps1
# Compliant if PowerShell Transcription is ENABLED (EnableTranscripting == 1)
Configuration Audit_PSTranscription_Enabled {
  Import-DscResource -ModuleName PSDscResources

  Node 'localhost' {
    Script CheckTranscription {
      GetScript = @'
$path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\Transcription"
$props = Get-ItemProperty -Path $path -ErrorAction SilentlyContinue
$enabled = $props.EnableTranscripting
$dir = $props.OutputDirectory
$inv = $props.EnableInvocationHeader
@{ Result = ("Enabled={0}; OutputDir={1}; InvocationHeader={2}" -f $enabled,$dir,$inv) }
'@
      TestScript = @'
$path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\Transcription"
$val  = (Get-ItemProperty -Path $path -Name EnableTranscripting -ErrorAction SilentlyContinue).EnableTranscripting
return ([int]$val -eq 1)
'@
      SetScript = 'return $true'  # audit-only
    }
  }
}
Audit_PSTranscription_Enabled