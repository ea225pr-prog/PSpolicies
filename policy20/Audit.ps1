Configuration Audit_FullLanguage {
  Import-DscResource -ModuleName PSDscResources
  Node 'localhost' {
    Script CheckLang {
      GetScript = @'
$lm = [string]$ExecutionContext.SessionState.LanguageMode
@{ Result = "LanguageMode=$lm" }
'@
      TestScript = @'
$lm = [string]$ExecutionContext.SessionState.LanguageMode
return ($lm -eq 'FullLanguage')
'@
      SetScript = 'return $true'
    }
  }
}
Audit_FullLanguage


