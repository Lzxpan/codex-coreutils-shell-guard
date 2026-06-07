# Coreutils Hook Candidate

## Purpose

This is a design candidate only. It is not installed.

The goal is to make Codex more likely to run Coreutils commands safely on Windows without changing every PowerShell command. The hook should prepare or warn; it should not rewrite arbitrary commands.

## Why Not Install Immediately

- Hooks run automatically and need explicit trust.
- A broad hook could change unrelated shell behavior.
- PowerShell aliases such as `cat` and `ls` are context-sensitive; automatic rewriting could surprise the user.
- Encoding problems still require `powershell-utf8-guard`, so Coreutils alone is not a complete fix.

## Candidate Behavior

A safe first hook candidate may:

- Detect whether `C:\Program Files\coreutils\bin` exists.
- Warn when the current shell cannot find `grep.exe`, `cat.exe`, `wc.exe`, or `xargs.exe`.
- Suggest explicit `.exe` names when PowerShell aliases are detected.
- Refuse to claim success unless `Test-CoreutilsWindows.ps1` passes.

It should not:

- Modify `$PROFILE`.
- Change system PATH.
- Rewrite `cat` to `cat.exe` automatically.
- Rewrite user commands that contain paths, quotes, redirects, pipes, or variables.
- Suppress native error messages.

## Verification Before Installation

Before any hook is installed, verify:

```powershell
& "C:\Users\Admin\.codex\skills\coreutils-windows-native-tools\scripts\Test-CoreutilsWindows.ps1"
```

Required result:

- `CoreutilsBinExists` is `True`.
- `RoundTripPassed` is `True`.
- The hook plan includes rollback instructions.
- The user explicitly approves installing the hook.

## Rollback Requirement

Any hook installation must document:

- exact files created or modified,
- how to disable the hook,
- how to delete the hook,
- how to restore previous Codex settings.
