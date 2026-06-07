# COREUTILS_SHELL_GUARD_TRUSTED_TEST_RECEIPT_20260607_230359

## Summary

execution_label: real execution

使用者已在 Codex Hook 設定頁完成信任授權後，本輪執行完整檢查。

## UI Evidence

- 使用者截圖顯示 Hook 設定頁已有：
  - `使用者設定`：`2 個 Hook`
  - `coreutils-shell-guard`：`2 個 Hook`

## Verified

- `C:\Users\Admin\.codex\hooks.json` JSON 可讀。
- `C:\Users\Admin\plugins\coreutils-shell-guard\hooks.json` JSON 可讀。
- `C:\Users\Admin\.codex\plugins\cache\personal\coreutils-shell-guard\0.1.0\hooks.json` JSON 可讀。
- `C:\Users\Admin\.codex\config.toml` 包含：
  - `[features]`
  - `codex_hooks = true`
  - `[plugins."coreutils-shell-guard@personal"]`
  - `[marketplaces.personal]`
- `quick_validate.py` 對 `C:\Users\Admin\.codex\plugins\cache\personal\coreutils-shell-guard\0.1.0\skills\coreutils-shell-guard` 回報 `Skill is valid!`。
- `session-start.ps1` 手動執行成功，輸出 `[coreutils-shell-guard] Windows shell reminder...`。
- `post-shell-check.ps1` 使用 `TOOL_INPUT='cat file.txt > out.txt'` 手動執行成功，輸出 UTF-8 與 PowerShell alias 提醒。
- 實際 PowerShell round-trip 測試成功：
  - 建立 `%TEMP%\codex-coreutils-shell-guard-test\file.txt`
  - 執行 `cat file.txt > out.txt`
  - 使用 `Get-Content -Encoding utf8` 讀回 `繁體中文測試`
- `codex exec` 測試不再出現 `coreutils-shell-guard@personal` plugin 載入錯誤。

## Not Verified

- `codex exec` 輸出中沒有顯示 `[coreutils-shell-guard]` hook 提醒。
- 目前本地 `read_thread_terminal` 回報 `No app terminal session is attached to this thread yet.`，無法從這個 thread 讀到桌面端 hook UI 輸出。
- 因此 `SessionStart` 與 `PostToolUse` 的桌面端自動觸發仍標記為 `not_verified`，但 Hook 設定頁已能看到來源與數量。

## Interpretation

Hook 設定、信任、plugin 載入與腳本本體都已恢復到可用狀態。剩餘未驗證點是 Codex 是否會把 hook 輸出顯示在目前對話或終端；目前 CLI 子流程沒有顯示 hook 訊息，不能拿來當作已觸發證據。

