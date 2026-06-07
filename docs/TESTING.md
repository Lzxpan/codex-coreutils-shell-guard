# 測試方式

## 一、檢查技能

```powershell
$env:PYTHONUTF8='1'; & "C:\Users\Admin\.codex\skill-runtimes\musicgen-local\.venv\Scripts\python.exe" "C:\Users\Admin\.codex\skills\.system\skill-creator\scripts\quick_validate.py" "skills\coreutils-windows-native-tools"
```

預期看到：

```text
Skill is valid!
```

## 二、檢查 JSON

JSON 是結構化文字。這裡用來確認 plugin 和掛鉤設定沒有格式錯誤。

```powershell
python -m json.tool "plugins\coreutils-shell-guard\.codex-plugin\plugin.json"
python -m json.tool "plugins\coreutils-shell-guard\hooks.json"
python -m json.tool ".agents\plugins\marketplace.json"
```

三個命令都能正常輸出 JSON，代表格式可讀。

## 三、測試 Coreutils

```powershell
& "skills\coreutils-windows-native-tools\scripts\Test-CoreutilsWindows.ps1"
```

重點看：

- `CoreutilsBinExists` 是否為 `True`。
- `grep.exe`、`cat.exe`、`wc.exe`、`xargs.exe` 是否能找到。
- `RoundTripPassed` 是否為 `True`。

`RoundTripPassed` 是中文來回測試，意思是中文寫出去再讀回來沒有壞。

## 四、測試掛鉤腳本

```powershell
& "plugins\coreutils-shell-guard\scripts\session-start.ps1"
$env:TOOL_INPUT = 'cat file.txt > out.txt'; & "plugins\coreutils-shell-guard\scripts\post-shell-check.ps1"
```

預期看到 `[coreutils-shell-guard]` 開頭的提醒。

## 五、實際 shell 情境

建立暫存測試資料：

```powershell
$utf8NoBom = [System.Text.UTF8Encoding]::new($false)
[Console]::InputEncoding = $utf8NoBom
[Console]::OutputEncoding = $utf8NoBom
$OutputEncoding = $utf8NoBom
chcp.com 65001 > $null
$testDir = Join-Path $env:TEMP "codex-coreutils-shell-guard-e2e"
New-Item -ItemType Directory -Force -Path $testDir | Out-Null
Set-Content -LiteralPath (Join-Path $testDir "file.txt") -Value @("alpha", "繁體中文測試", "beta") -Encoding utf8
```

執行：

```powershell
Push-Location $env:TEMP\codex-coreutils-shell-guard-e2e
$env:Path = "C:\Program Files\coreutils\bin;$env:Path"
cat.exe file.txt | grep.exe "繁體中文" | wc.exe -l
Pop-Location
```

預期輸出：

```text
1
```

## 六、測試互動頁

推薦直接開線上版：

[開啟互動教學：Codex Coreutils Shell Guard](https://lzxpan.github.io/codex-coreutils-shell-guard/)

如果你已經把 repo 下載到本機，也可以在 repo 根目錄執行：

```powershell
Start-Process ".\docs\index.html"
```

確認：

- 可以用左右方向鍵切換。
- 按鈕可以切換情境。
- 複製按鈕可用。
- 中文顯示正常。
- 沒有文字溢出。
