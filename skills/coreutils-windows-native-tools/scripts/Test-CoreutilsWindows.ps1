param(
    [string]$CoreutilsBin = "C:\Program Files\coreutils\bin"
)

$ErrorActionPreference = "Stop"

$utf8NoBom = [System.Text.UTF8Encoding]::new($false)
[Console]::InputEncoding = $utf8NoBom
[Console]::OutputEncoding = $utf8NoBom
$OutputEncoding = $utf8NoBom
chcp.com 65001 > $null

function Get-CommandSummary {
    param([string]$Name)

    $cmd = Get-Command $Name -ErrorAction SilentlyContinue | Select-Object -First 1
    if (-not $cmd) {
        return [pscustomobject]@{
            Name = $Name
            Found = $false
            CommandType = $null
            Source = $null
        }
    }

    return [pscustomobject]@{
        Name = $Name
        Found = $true
        CommandType = $cmd.CommandType.ToString()
        Source = if ($cmd.Source) { $cmd.Source } elseif ($cmd.Definition) { $cmd.Definition } else { $cmd.Path }
    }
}

$coreutilsBinExists = Test-Path -LiteralPath $CoreutilsBin
$pathParts = $env:Path -split ';' | Where-Object { $_ }
$coreutilsBinOnPath = $pathParts -contains $CoreutilsBin

if ($coreutilsBinExists -and -not $coreutilsBinOnPath) {
    $env:Path = "$CoreutilsBin;$env:Path"
}

$commands = @(
    Get-CommandSummary "grep.exe"
    Get-CommandSummary "cat"
    Get-CommandSummary "cat.exe"
    Get-CommandSummary "wc.exe"
    Get-CommandSummary "xargs.exe"
    Get-CommandSummary "find.exe"
    Get-CommandSummary "ls"
    Get-CommandSummary "ls.exe"
)

$sampleText = "繁體中文測試"
$tempDir = Join-Path ([System.IO.Path]::GetTempPath()) ("coreutils-utf8-test-" + [guid]::NewGuid().ToString("N"))
New-Item -ItemType Directory -Path $tempDir | Out-Null
$samplePath = Join-Path $tempDir "sample.txt"

$roundTripPassed = $false
$grepOutput = $null
$catOutput = $null
$wcOutput = $null
$testError = $null

try {
    Set-Content -LiteralPath $samplePath -Value @($sampleText, "ASCII line") -Encoding utf8

    $grep = Get-Command "grep.exe" -ErrorAction SilentlyContinue | Select-Object -First 1
    $cat = Get-Command "cat.exe" -ErrorAction SilentlyContinue | Select-Object -First 1
    $wc = Get-Command "wc.exe" -ErrorAction SilentlyContinue | Select-Object -First 1

    if ($grep -and $cat -and $wc) {
        $grepOutput = & $grep.Path "繁體中文" $samplePath
        $catOutput = & $cat.Path $samplePath
        $wcOutput = & $wc.Path -l $samplePath
        $roundTripPassed = (($grepOutput -join "`n") -like "*$sampleText*") -and (($catOutput -join "`n") -like "*$sampleText*")
    }
} catch {
    $testError = $_.Exception.Message
} finally {
    Remove-Item -LiteralPath $tempDir -Recurse -Force -ErrorAction SilentlyContinue
}

[pscustomobject]@{
    PSVersion = $PSVersionTable.PSVersion.ToString()
    ConsoleInputCodePage = [Console]::InputEncoding.CodePage
    ConsoleOutputCodePage = [Console]::OutputEncoding.CodePage
    OutputEncodingCodePage = $OutputEncoding.CodePage
    CoreutilsBin = $CoreutilsBin
    CoreutilsBinExists = $coreutilsBinExists
    CoreutilsBinOnPathAtStart = $coreutilsBinOnPath
    CoreutilsBinPrependedForTest = ($coreutilsBinExists -and -not $coreutilsBinOnPath)
    CommandResolution = $commands
    GrepOutput = $grepOutput
    CatOutput = $catOutput
    WcOutput = $wcOutput
    RoundTripPassed = $roundTripPassed
    Error = $testError
} | ConvertTo-Json -Depth 5
