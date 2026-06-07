# COREUTILS_SHELL_GUARD_HOOK_REPAIR_RECEIPT_20260607_225824

## Summary

execution_label: real execution

本輪修復 `coreutils-shell-guard` 在 Codex Hook 設定頁空白與 CLI 載入錯誤的問題。

## Changed

- 已備份 `C:\Users\Admin\.codex\config.toml`
- 已備份 `C:\Users\Admin\.agents\plugins\marketplace.json`
- 備份位置：`C:\Users\Admin\.codex\hook_repair_backups\20260607_224208`
- 已執行 `codex plugin marketplace add C:\Users\Admin`
- 已確認 `C:\Users\Admin\.codex\config.toml` 新增 `[marketplaces.personal]`
- 已新增 `[plugins."coreutils-shell-guard@personal"] enabled = true`
- 已把 plugin 快取改成三層格式：
  `C:\Users\Admin\.codex\plugins\cache\personal\coreutils-shell-guard\0.1.0`
- 已將原本平鋪快取移到：
  `C:\Users\Admin\.codex\hook_repair_backups\20260607_224208\cache_coreutils_shell_guard_flat`
- 已把來源與快取內的 `hooks.json` 命令改為相對路徑：
  `./scripts/session-start.ps1`
  `./scripts/post-shell-check.ps1`
- 已新增全域 hook fallback：
  `C:\Users\Admin\.codex\hooks.json`
- 已啟用 hook 功能旗標：
  `codex_hooks = true`

## Verified

- `C:\Users\Admin\.agents\plugins\marketplace.json` JSON 可讀。
- `C:\Users\Admin\plugins\coreutils-shell-guard\.codex-plugin\plugin.json` JSON 可讀。
- `C:\Users\Admin\plugins\coreutils-shell-guard\hooks.json` JSON 可讀。
- `C:\Users\Admin\.codex\plugins\cache\personal\coreutils-shell-guard\0.1.0\.codex-plugin\plugin.json` JSON 可讀。
- `C:\Users\Admin\.codex\plugins\cache\personal\coreutils-shell-guard\0.1.0\hooks.json` JSON 可讀。
- `C:\Users\Admin\.codex\hooks.json` JSON 可讀。
- `quick_validate.py` 對 plugin 內 skill 回報 `Skill is valid!`。
- `session-start.ps1` 手動執行成功。
- `post-shell-check.ps1` 使用 `TOOL_INPUT='cat file.txt > out.txt'` 手動執行成功。
- `codex exec` 不再出現：
  `failed to load plugin: plugin is not installed plugin="coreutils-shell-guard@personal"`
- `codex exec` 不再出現：
  `missing or invalid plugin.json plugin="coreutils-shell-guard@personal" path=C:\Users\Admin\.codex\plugins\cache\personal\coreutils-shell-guard\skills`

## Not Verified

- Codex 桌面 Hook 設定頁是否已顯示 hook：not_verified，需要重開 Codex 後人工刷新確認。
- `SessionStart` 在桌面新對話是否會顯示 `[coreutils-shell-guard]`：not_verified，需要重開 Codex 後確認。
- `PostToolUse` 在桌面 shell 工具後是否會顯示 `[coreutils-shell-guard]`：not_verified，需要重開 Codex 後確認。

## Notes

`codex exec` 已可載入 plugin 而不報 `coreutils-shell-guard@personal` 載入錯誤，但沒有印出 hook 提醒。這可能是 `codex exec` 不顯示或不觸發桌面 lifecycle hook，也可能是 hook 需要桌面端信任後才執行。

下一步請重開 Codex，進入 Hook 設定頁刷新，確認是否顯示 `C:\Users\Admin\.codex\hooks.json` 或 `coreutils-shell-guard@personal` 的 hook。

