param(
    [string]$ToolInput
)

$ErrorActionPreference = "SilentlyContinue"

if (-not $ToolInput) {
    $ToolInput = $env:TOOL_INPUT
}

if (-not $ToolInput) {
    return
}

$messages = New-Object System.Collections.Generic.List[string]
$prelude = "[coreutils-shell-guard]"

$hasNonAscii = [regex]::IsMatch($ToolInput, "[^\u0000-\u007F]")
$hasTextRedirection = [regex]::IsMatch($ToolInput, "(^|\s)(>|>>|Out-File|Set-Content|Add-Content|Get-Content|ConvertTo-Json|ConvertFrom-Json)(\s|$)", "IgnoreCase")
$hasPipeline = $ToolInput -match "\|"
$hasAliasRisk = [regex]::IsMatch($ToolInput, "(^|[;&|\s])(cat|ls|grep|wc|xargs)(\s|$)", "IgnoreCase")
$hasExplicitCoreutils = [regex]::IsMatch($ToolInput, "(^|[;&|\s])(grep|cat|wc|xargs|find|ls)\.exe(\s|$)", "IgnoreCase")

if ($hasNonAscii -or $hasTextRedirection -or $hasPipeline) {
    $messages.Add("$prelude This shell command handled text that may need encoding care. For Chinese, Unicode, JSON, logs, Markdown, YAML, redirected output, or external program pipelines, use `$powershell-utf8-guard before running the command.")
}

if ($hasAliasRisk -and -not $hasExplicitCoreutils) {
    $messages.Add("$prelude Possible PowerShell alias or Coreutils ambiguity detected. If you intended Coreutils, use explicit names such as grep.exe, cat.exe, wc.exe, or xargs.exe and consider `$coreutils-windows-native-tools.")
}

foreach ($message in $messages) {
    Write-Output $message
}
