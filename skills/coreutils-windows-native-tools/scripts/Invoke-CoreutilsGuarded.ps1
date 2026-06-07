param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Tool,

    [Parameter(Position = 1, ValueFromRemainingArguments = $true)]
    [string[]]$Arguments,

    [string]$CoreutilsBin = "C:\Program Files\coreutils\bin"
)

$ErrorActionPreference = "Stop"

$utf8NoBom = [System.Text.UTF8Encoding]::new($false)
[Console]::InputEncoding = $utf8NoBom
[Console]::OutputEncoding = $utf8NoBom
$OutputEncoding = $utf8NoBom
chcp.com 65001 > $null

if (Test-Path -LiteralPath $CoreutilsBin) {
    $env:Path = "$CoreutilsBin;$env:Path"
}

$toolName = if ($Tool.EndsWith(".exe", [System.StringComparison]::OrdinalIgnoreCase)) {
    $Tool
} else {
    "$Tool.exe"
}

$candidate = Join-Path $CoreutilsBin $toolName
if (Test-Path -LiteralPath $candidate) {
    $exePath = $candidate
} else {
    $resolved = Get-Command $toolName -ErrorAction SilentlyContinue | Select-Object -First 1
    if (-not $resolved) {
        throw "Coreutils command not found: $toolName"
    }
    $exePath = $resolved.Path
}

& $exePath @Arguments
if ($LASTEXITCODE -ne $null) {
    exit $LASTEXITCODE
}
