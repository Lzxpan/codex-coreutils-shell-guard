# codex-coreutils-shell-guard 發布回執

建立時間：2026-06-07 23:45:13 +08:00

## 結論

`codex-coreutils-shell-guard` 已發布到 GitHub。

- Repo: https://github.com/Lzxpan/codex-coreutils-shell-guard
- GitHub Pages: https://lzxpan.github.io/codex-coreutils-shell-guard/
- 內容 commit: `e732dd1e784e756845fead45eba21b14b52f4624`
- visibility: `PUBLIC`
- 授權: `MIT`

## 已包含內容

- `skills/coreutils-windows-native-tools`
- `plugins/coreutils-shell-guard`
- `.agents/plugins/marketplace.json`
- `README.md`
- `INSTALL.md`
- `docs/index.html`
- `docs/SKILL_VS_HOOK.md`
- `docs/USAGE_SCENARIOS.md`
- `docs/TESTING.md`
- `docs/ROLLBACK.md`
- `docs/assets/tech-comic-coreutils-guard.png`
- `docs/receipts/`

## real execution 驗證

`real execution` 是真實執行，意思是命令真的跑過，不是只寫計畫。

- `quick_validate.py` 檢查 `skills/coreutils-windows-native-tools`：通過，輸出 `Skill is valid!`
- `python -m json.tool` 檢查：
  - `plugins/coreutils-shell-guard/.codex-plugin/plugin.json`
  - `plugins/coreutils-shell-guard/hooks.json`
  - `.agents/plugins/marketplace.json`
  結果：通過。
- `Test-CoreutilsWindows.ps1`：通過。
  - `CoreutilsBinExists`: `true`
  - `RoundTripPassed`: `true`
  - `cat` 解析為 PowerShell alias。
  - `cat.exe`、`grep.exe`、`wc.exe`、`xargs.exe` 解析到 `C:\Program Files\coreutils\bin`。
- `session-start.ps1`：通過，輸出 `[coreutils-shell-guard]` 提醒。
- `post-shell-check.ps1` 搭配 `$env:TOOL_INPUT = 'cat file.txt > out.txt'`：通過，輸出 alias 與 UTF-8 風險提醒。
- Chrome 本機頁面檢查：通過。
  - `docs/index.html` 可開啟。
  - 6 張投影片存在。
  - 主圖片載入。
  - 情境按鈕可切換。
  - 複製按鈕可用。
  - 沒有 `繁繁中文`。
  - 投影片沒有內容溢出。
- GitHub Pages：通過。
  - `status`: `built`
  - HTTP 狀態：`200`
  - 頁面標題：`Codex Coreutils Shell Guard 互動教學`
  - 正式頁面圖片載入成功。

## not_verified

`not_verified` 是尚未驗證，意思是本輪沒有真的做。

- 未從 GitHub repo 重新安裝技能到 `C:\Users\Admin\.codex\skills`，因為本輪目標是發布分享，不覆蓋目前正式技能。
- 未從 GitHub repo 重新安裝 plugin 到正式個人 marketplace，因為這可能影響目前已信任的本機掛鉤。
- 未驗證其他使用者電腦上的 `codex plugin marketplace add` 行為，因為那需要另一台乾淨環境。

## 備註

- 圖片使用 `imagegen` 生成後複製到 `docs/assets/tech-comic-coreutils-guard.png`。
- 圖片提示詞明確要求無文字、無商標、無既有角色；所有教學文字都由 HTML/CSS 呈現，避免圖片文字錯字。
- Chrome 不能直接開 `file:///...`，因此本機 HTML 檢查改用臨時 `http://127.0.0.1:8765/docs/index.html`，測試後已關閉該臨時服務。
