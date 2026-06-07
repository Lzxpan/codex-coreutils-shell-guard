---
name: coreutils-shell-guard
description: Use when reviewing or maintaining the local Coreutils Shell Guard plugin hooks that remind Codex to apply powershell-utf8-guard and coreutils-windows-native-tools during Windows PowerShell shell work.
---

# Coreutils Shell Guard

## Purpose

This plugin skill describes the local reminder hooks for shell safety. It does not replace the global skills:

- `powershell-utf8-guard`
- `coreutils-windows-native-tools`

## Rules

- Hooks may remind or diagnose only.
- Hooks must not rewrite commands.
- Hooks must not modify `$PROFILE`.
- Hooks must not modify system PATH.
- Hooks must not hide native command output or errors.

## Verification

Use these checks after changing the plugin:

```powershell
python -m json.tool "C:\Users\Admin\plugins\coreutils-shell-guard\.codex-plugin\plugin.json"
python -m json.tool "C:\Users\Admin\plugins\coreutils-shell-guard\hooks.json"
& "C:\Users\Admin\plugins\coreutils-shell-guard\scripts\session-start.ps1"
$env:TOOL_INPUT = 'cat file.txt > out.txt'; & "C:\Users\Admin\plugins\coreutils-shell-guard\scripts\post-shell-check.ps1"
```

Label manual script checks as `real execution`. Label hook triggering inside Codex as `not_verified` until Codex is restarted and the hook output is observed.
