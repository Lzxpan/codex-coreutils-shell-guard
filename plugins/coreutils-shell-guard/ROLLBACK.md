# Coreutils Shell Guard Rollback

## What This Plugin Changes

This plugin adds a local personal plugin and marketplace entry:

- `C:\Users\Admin\plugins\coreutils-shell-guard`
- `C:\Users\Admin\.agents\plugins\marketplace.json`

It does not modify:

- `$PROFILE`
- system PATH
- `C:\Users\Admin\.codex\config.toml`
- `C:\Users\Admin\.codex\skills\powershell-utf8-guard`
- `C:\Users\Admin\.codex\skills\coreutils-windows-native-tools`

## Disable

To stop automatic loading without deleting files, edit:

```text
C:\Users\Admin\.agents\plugins\marketplace.json
```

Change:

```json
"installation": "INSTALLED_BY_DEFAULT"
```

to:

```json
"installation": "AVAILABLE"
```

Restart Codex after the change.

## Remove

To remove the plugin completely:

1. Delete the `coreutils-shell-guard` entry from:

```text
C:\Users\Admin\.agents\plugins\marketplace.json
```

2. Delete the plugin folder:

```powershell
Remove-Item -LiteralPath "C:\Users\Admin\plugins\coreutils-shell-guard" -Recurse -Force
```

3. Restart Codex.

## Verify Removal

After restart, confirm the plugin no longer appears in the plugin list and no `[coreutils-shell-guard]` messages appear at session start or after shell tool use.
