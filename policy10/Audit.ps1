Configuration Audit_NoConstrainedLanguage {
  Import-DscResource -ModuleName PSDscResources
  Node 'localhost' {
    Script CheckLang {
      GetScript  = '@{ Result = "LanguageMode=$($ExecutionContext.SessionState.LanguageMode)" }'
      TestScript = "return ($ExecutionContext.SessionState.LanguageMode -ne 'ConstrainedLanguage')"
      SetScript  = 'return $true'
    }
  }
}
Audit_NoConstrainedLanguage
