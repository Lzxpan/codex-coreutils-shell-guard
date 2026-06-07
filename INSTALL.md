# 安裝說明

這份文件提供三種安裝方式。

## 方式一：只安裝技能

如果你只想讓 Codex 學會怎麼使用 Coreutils，安裝技能即可。

```powershell
$env:PYTHONUTF8='1'; & "C:\Users\Admin\.codex\skill-runtimes\musicgen-local\.venv\Scripts\python.exe" "C:\Users\Admin\.codex\skills\.system\skill-installer\scripts\install-skill-from-github.py" --repo Lzxpan/codex-coreutils-shell-guard --path skills/coreutils-windows-native-tools
```

安裝後重開 Codex。

## 方式二：安裝技能與掛鉤

這個方式適合希望 Codex 自動提醒的人。

1. 安裝技能。
2. 把 repo clone 到本機：

```powershell
git clone https://github.com/Lzxpan/codex-coreutils-shell-guard.git "C:\Users\Admin\plugins\codex-coreutils-shell-guard"
```

3. 將 plugin 資料夾放到個人 plugin 位置：

```powershell
Copy-Item -LiteralPath "C:\Users\Admin\plugins\codex-coreutils-shell-guard\plugins\coreutils-shell-guard" -Destination "C:\Users\Admin\plugins\coreutils-shell-guard" -Recurse -Force
```

4. 確認 `C:\Users\Admin\.agents\plugins\marketplace.json` 有註冊 `coreutils-shell-guard`。

5. 註冊 marketplace：

```powershell
codex plugin marketplace add C:\Users\Admin
```

6. 重開 Codex，進入掛鉤設定頁，授權信任 `coreutils-shell-guard`。

掛鉤（原詞：hook，意思是 Codex 在特定時機自動跑的小提醒）需要信任後才會執行。

## 方式三：手動安裝

手動複製技能：

```powershell
Copy-Item -LiteralPath "skills\coreutils-windows-native-tools" -Destination "C:\Users\Admin\.codex\skills\coreutils-windows-native-tools" -Recurse -Force
```

手動複製 plugin：

```powershell
Copy-Item -LiteralPath "plugins\coreutils-shell-guard" -Destination "C:\Users\Admin\plugins\coreutils-shell-guard" -Recurse -Force
```

然後重開 Codex。

## 安裝後驗證

技能格式檢查：

```powershell
$env:PYTHONUTF8='1'; & "C:\Users\Admin\.codex\skill-runtimes\musicgen-local\.venv\Scripts\python.exe" "C:\Users\Admin\.codex\skills\.system\skill-creator\scripts\quick_validate.py" "C:\Users\Admin\.codex\skills\coreutils-windows-native-tools"
```

掛鉤 JSON 檢查：

```powershell
python -m json.tool "C:\Users\Admin\plugins\coreutils-shell-guard\.codex-plugin\plugin.json"
python -m json.tool "C:\Users\Admin\plugins\coreutils-shell-guard\hooks.json"
```

手動執行掛鉤腳本：

```powershell
& "C:\Users\Admin\plugins\coreutils-shell-guard\scripts\session-start.ps1"
$env:TOOL_INPUT = 'cat file.txt > out.txt'; & "C:\Users\Admin\plugins\coreutils-shell-guard\scripts\post-shell-check.ps1"
```

看到 `[coreutils-shell-guard]` 開頭的提醒，代表腳本本體可以執行。

如果 Codex UI 裡沒有看到掛鉤提醒，先檢查是否已重開 Codex，以及是否已在掛鉤設定頁信任該掛鉤。
