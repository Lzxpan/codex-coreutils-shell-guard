$ErrorActionPreference = "SilentlyContinue"

$coreutilsBin = "C:\Program Files\coreutils\bin"
$coreutilsExists = Test-Path -LiteralPath $coreutilsBin
$isWindows = [System.Runtime.InteropServices.RuntimeInformation]::IsOSPlatform(
    [System.Runtime.InteropServices.OSPlatform]::Windows
)

if (-not $isWindows) {
    return
}

$inputCodePage = [Console]::InputEncoding.CodePage
$outputCodePage = [Console]::OutputEncoding.CodePage
$prelude = "[coreutils-shell-guard]"

Write-Output "$prelude Windows shell reminder: use `$powershell-utf8-guard before PowerShell commands that handle Chinese, Unicode, JSON, logs, Markdown, YAML, redirected output, or external program pipelines."

if ($coreutilsExists) {
    Write-Output "$prelude Coreutils found at `"$coreutilsBin`". When using Coreutils in PowerShell, prefer explicit names: grep.exe, cat.exe, wc.exe, xargs.exe."
} else {
    Write-Output "$prelude Coreutils path not found: `"$coreutilsBin`". If Coreutils is needed, run the coreutils-windows-native-tools diagnostic first."
}

if ($inputCodePage -ne 65001 -or $outputCodePage -ne 65001) {
    Write-Output "$prelude Current console code pages are Input=$inputCodePage Output=$outputCodePage. For Chinese or Unicode text, apply the UTF-8 guard preamble before running shell commands."
}
