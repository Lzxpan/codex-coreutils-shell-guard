# COREUTILS_SHELL_GUARD_E2E_SCENARIO_TEST_20260607_231253

## Summary

execution_label: real execution

本輪依照 `coreutils-shell-guard` 實測情境設計執行測試。測試目的：確認技能、hook 設定、手動 hook 腳本、Coreutils 命令與 UTF-8 中文 round-trip 是否可用。

## Environment

- Test directory: `%TEMP%\codex-coreutils-shell-guard-e2e`
- Resolved path: `C:\Users\Admin\AppData\Local\Temp\codex-coreutils-shell-guard-e2e`
- Test file: `file.txt`
- Output file: `out.txt`
- Test text: `繁體中文測試`

## Configuration Checks

- `C:\Users\Admin\.codex\hooks.json`: JSON readable.
- `C:\Users\Admin\plugins\coreutils-shell-guard\hooks.json`: JSON readable.
- `C:\Users\Admin\.codex\plugins\cache\personal\coreutils-shell-guard\0.1.0\hooks.json`: JSON readable.
- `C:\Users\Admin\.codex\config.toml` contains `codex_hooks = true`.
- `C:\Users\Admin\.codex\config.toml` contains `[plugins."coreutils-shell-guard@personal"]`.
- `C:\Users\Admin\.codex\config.toml` contains `[marketplaces.personal]`.
- `C:\Users\Admin\.codex\config.toml` contains trusted hashes for:
  - `C:\Users\Admin\.codex\hooks.json:post_tool_use:0:0`
  - `C:\Users\Admin\.codex\hooks.json:session_start:0:0`
  - `coreutils-shell-guard@personal:hooks.json:post_tool_use:0:0`
  - `coreutils-shell-guard@personal:hooks.json:session_start:0:0`

## Coreutils Checks

- `C:\Program Files\coreutils\bin` exists.
- `cat.exe` resolves to `C:\Program Files\coreutils\bin\cat.exe`.
- `grep.exe` resolves to `C:\Program Files\coreutils\bin\grep.exe`.
- `wc.exe` resolves to `C:\Program Files\coreutils\bin\wc.exe`.
- `cat` resolves as a PowerShell alias, so alias-risk detection is meaningful.

## Hook Script Checks

Manual `SessionStart` script:

- Command: `& "C:\Users\Admin\plugins\coreutils-shell-guard\scripts\session-start.ps1"`
- Result: printed `[coreutils-shell-guard] Windows shell reminder...`
- Result: printed Coreutils location reminder.

Manual `PostToolUse` script:

- `Write-Output "plain-ascii"`: no warning, as expected.
- `cat file.txt`: printed alias/Coreutils ambiguity warning, as expected.
- `cat file.txt > out.txt`: printed UTF-8/text warning and alias ambiguity warning, as expected.
- `cat.exe file.txt | grep.exe "繁體中文" | wc.exe -l`: printed UTF-8/pipeline warning, and did not print alias ambiguity warning, as expected.

## Command Scenario Results

Test 1: `SessionStart`

- Status: partially verified.
- Manual script passed.
- Codex UI already shows trusted hook entries.
- Automatic visible output in this thread: not_verified.

Test 2: plain ASCII command

- Command: `Write-Output "plain-ascii"`
- Result: output was `plain-ascii`.
- Expected warning: none.
- Status: passed.

Test 3: alias-risk command

- Command: `cat file.txt`
- Result:
  - `alpha`
  - `繁體中文測試`
  - `beta`
- Manual `PostToolUse` expected warning: alias ambiguity warning.
- Status: passed for command and manual hook logic.

Test 4: UTF-8 / redirection command

- Command: `cat file.txt > out.txt`
- Verification command: `Get-Content -LiteralPath .\out.txt -Encoding utf8`
- Result:
  - `alpha`
  - `繁體中文測試`
  - `beta`
- Manual `PostToolUse` expected warnings: UTF-8/text warning and alias ambiguity warning.
- Status: passed for command and manual hook logic.

Test 5: explicit Coreutils pipeline

- Command: `cat.exe file.txt | grep.exe "繁體中文" | wc.exe -l`
- Result: `1`
- Manual `PostToolUse` expected warning: UTF-8/pipeline warning only.
- Manual `PostToolUse` expected non-warning: no alias ambiguity warning.
- Status: passed for command and manual hook logic.

## Not Verified

- `PostToolUse` automatic hook output was not visible in this thread after shell tool calls.
- `read_thread_terminal` returned `No app terminal session is attached to this thread yet.`
- Therefore automatic desktop hook visibility remains `not_verified`.

## Conclusion

The skill and hook scripts are useful and correctly detect the intended shell risks. The full command scenarios passed, including UTF-8 Chinese round-trip and explicit Coreutils pipeline behavior. Hook trust is present in `config.toml`. The only remaining gap is visibility of automatic hook output in this current Codex thread.

