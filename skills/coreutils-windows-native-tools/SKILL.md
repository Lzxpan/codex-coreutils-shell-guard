---
name: coreutils-windows-native-tools
description: Use when Codex runs Windows shell or PowerShell tasks that can benefit from Microsoft Coreutils for Windows or uutils commands such as grep.exe, cat.exe, wc.exe, xargs.exe, find.exe, or coreutils.exe, especially when PowerShell aliases, PATH visibility, text search, line counting, pipelines, or UTF-8 handling matter.
---

# Coreutils Windows Native Tools

## Overview

Use this skill to choose Windows-native Coreutils commands safely from Codex. Coreutils can make text search, line counting, file display, and pipeline work more familiar and repeatable on Windows.

Coreutils does not replace `powershell-utf8-guard`. When commands handle Chinese, Unicode, JSON, logs, Markdown, YAML, or redirected output, apply the UTF-8 guard first.

## When to Use

Use this skill when:

- Searching text with `grep.exe`.
- Displaying file text with `cat.exe`.
- Counting lines, words, or bytes with `wc.exe`.
- Building native command pipelines with `xargs.exe`.
- Checking command availability or PATH issues for Coreutils.
- Avoiding PowerShell aliases such as `cat` mapping to `Get-Content` or `ls` mapping to `Get-ChildItem`.
- Reproducing Linux-like command examples on Windows without switching away from PowerShell.

Do not use this skill when:

- A PowerShell cmdlet is clearer and the task does not need Coreutils behavior.
- The task is binary-safe file copying or editing.
- The issue is only Chinese mojibake. Use `powershell-utf8-guard` first because Coreutils alone cannot fix console encoding.
- The user asked for a POSIX shell environment such as WSL, Git Bash, MSYS2, or Cygwin.

## Safe Defaults

1. Apply `powershell-utf8-guard` before commands that may handle Chinese or Unicode text.
2. Use explicit `.exe` names in PowerShell:
   - Prefer `grep.exe`, not `grep`.
   - Prefer `cat.exe`, not `cat`.
   - Prefer `wc.exe`, not `wc`.
   - Prefer `xargs.exe`, not `xargs`.
3. If Codex cannot find Coreutils in the current shell, temporarily prepend the expected install path:

```powershell
$coreutilsBin = "C:\Program Files\coreutils\bin"
if (Test-Path -LiteralPath $coreutilsBin) {
  $env:Path = "$coreutilsBin;$env:Path"
}
```

4. Do not permanently edit `$PROFILE` or system PATH unless the user explicitly asks.
5. Preserve exact command output and error messages when reporting failures.

## Command Choice

Use these mappings when a Coreutils command is more direct than PowerShell:

| Need | Prefer | Notes |
|---|---|---|
| Search text | `grep.exe` | Good for simple literal or regex searches. Use `rg` first if it is already available and better suited. |
| Show a file | `cat.exe` | In PowerShell, plain `cat` is usually an alias for `Get-Content`. |
| Count lines | `wc.exe -l` | Useful for quick size checks and validation counts. |
| Run one command per input item | `xargs.exe` | Be careful with spaces and Unicode paths. Prefer PowerShell loops for complex Windows paths. |
| Check a Coreutils command | `Get-Command <name>.exe` | Confirms what executable PowerShell will call. |

When a command touches paths with spaces, pass arguments as separate PowerShell arguments instead of building one long string.

## UTF-8 And Chinese Text

Coreutils can process UTF-8 text, but PowerShell still controls how text enters and leaves external programs. Before using Coreutils with Chinese or Unicode text, run:

```powershell
$utf8NoBom = [System.Text.UTF8Encoding]::new($false)
[Console]::InputEncoding = $utf8NoBom
[Console]::OutputEncoding = $utf8NoBom
$OutputEncoding = $utf8NoBom
chcp.com 65001 > $null
```

If Chinese output still appears corrupted, run `scripts/Test-CoreutilsWindows.ps1` and report:

- whether Coreutils was found,
- whether `C:\Program Files\coreutils\bin` was on PATH,
- whether aliases conflicted,
- whether the round-trip test passed.

## Diagnostics

Use the diagnostic script to inspect the current environment:

```powershell
& "C:\Users\Admin\.codex\skills\coreutils-windows-native-tools\scripts\Test-CoreutilsWindows.ps1"
```

Good signs:

- `CoreutilsBinExists` is `True`.
- `CoreutilsBinOnPath` is `True` or the script can temporarily prepend it.
- `grep.exe`, `cat.exe`, `wc.exe`, and `xargs.exe` resolve to `C:\Program Files\coreutils\bin`.
- `RoundTripPassed` is `True`.

Use the guarded runner when Codex needs one stable Coreutils command with UTF-8 settings already applied:

```powershell
& "C:\Users\Admin\.codex\skills\coreutils-windows-native-tools\scripts\Invoke-CoreutilsGuarded.ps1" grep.exe "繁體" "C:\path\to\file.txt"
```

## Hook Candidate

Do not install a hook by default. A hook is an automatic rule that can run around Codex activity, so it must be narrow, trusted, and easy to roll back.

If the user wants more automation later, read `references/codex-hook-candidate.md` first. The recommended hook candidate should only prepare or warn about environment state; it should not rewrite arbitrary user commands.

## Reporting Rules

When reporting use of this skill:

- Say whether `powershell-utf8-guard` was applied.
- Say whether Coreutils was found by PATH or by full path.
- Mention any PowerShell alias conflict, such as `cat` being `Get-Content`.
- Label checks as `real execution`, `dry-run`, `mock`, or `not run`.
- Do not claim Coreutils fixed encoding unless the UTF-8 round-trip test passed.

## Failure Repair

If Coreutils commands are not found:

1. Check whether `C:\Program Files\coreutils\bin` exists.
2. Temporarily prepend it to `$env:Path`.
3. Retry with explicit `.exe` names.
4. If still missing, check `winget list --id Microsoft.Coreutils --accept-source-agreements`.

If output is mojibake:

1. Apply `powershell-utf8-guard`.
2. Retry the same command.
3. Use `Set-Content -Encoding utf8` and `Get-Content -Encoding utf8` for test files.
4. If the problem remains, preserve the exact output and explain that the display or upstream program may still be using a different encoding.

## Examples

Search a UTF-8 Markdown file:

```powershell
$utf8NoBom = [System.Text.UTF8Encoding]::new($false)
[Console]::InputEncoding = $utf8NoBom
[Console]::OutputEncoding = $utf8NoBom
$OutputEncoding = $utf8NoBom
chcp.com 65001 > $null
$env:Path = "C:\Program Files\coreutils\bin;$env:Path"
grep.exe -n "繁體中文" "C:\Users\Admin\Documents\example.md"
```

Count lines in a log:

```powershell
$env:Path = "C:\Program Files\coreutils\bin;$env:Path"
wc.exe -l "C:\Users\Admin\Documents\output.log"
```

Check whether `cat` is an alias:

```powershell
Get-Command cat, cat.exe -ErrorAction SilentlyContinue
```
