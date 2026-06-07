# Codex Coreutils Shell Guard

這是一組給 Codex 在 Windows 上使用的技能與掛鉤。

它的目標很單純：讓 Codex 在 PowerShell 裡處理中文、JSON、Markdown、log、文字搜尋與管線時，少踩亂碼與 alias 的坑。

## 這套工具解決什麼

Windows 的 PowerShell 很好用，但有兩個常見問題：

1. 編碼容易混亂。
   例如中文檔案、JSON、Markdown 或 log 經過外部程式管線後，可能變成看不懂的符號。

2. 指令名稱容易被 alias 混淆。
   alias 是捷徑名稱。PowerShell 裡的 `cat` 通常不是 Coreutils 的 `cat.exe`，而是 `Get-Content` 的別名。這會讓同一個指令在 Windows 和 Linux 表現不一樣。

這個 repo 放了兩個東西：

| 名稱 | 類型 | 作用 |
|---|---|---|
| `coreutils-windows-native-tools` | 技能 | 教 Codex 什麼時候用 `grep.exe`、`cat.exe`、`wc.exe`、`xargs.exe`，並提醒要搭配 UTF-8 防護。 |
| `coreutils-shell-guard` | 掛鉤 | 在 Codex 工作階段開始與 shell 工具使用後，自動提醒可能的編碼與 alias 風險。 |

## 技能和掛鉤差在哪

技能像一本小手冊。Codex 需要知道「怎麼做」時會讀它。

掛鉤（原詞：hook，意思是 Codex 在特定時機自動跑的小檢查）像提醒器。它不負責做完整工作，只負責在容易出錯的時候提醒。

這套設計故意不讓掛鉤自動改寫命令，因為自動改命令可能造成更難追的問題。

## 為什麼不能只靠 Coreutils

`Coreutils for Windows` 可以提供 `grep.exe`、`cat.exe`、`wc.exe`、`xargs.exe` 這些工具，但它不能自己修好 PowerShell 的中文編碼環境。

所以正確做法是：

1. 先套 PowerShell UTF-8 防護。
2. 再用明確的 `.exe` 指令。

建議前置設定：

```powershell
$utf8NoBom = [System.Text.UTF8Encoding]::new($false)
[Console]::InputEncoding = $utf8NoBom
[Console]::OutputEncoding = $utf8NoBom
$OutputEncoding = $utf8NoBom
chcp.com 65001 > $null
```

## 典型用法

搜尋含中文的 Markdown：

```powershell
$utf8NoBom = [System.Text.UTF8Encoding]::new($false)
[Console]::InputEncoding = $utf8NoBom
[Console]::OutputEncoding = $utf8NoBom
$OutputEncoding = $utf8NoBom
chcp.com 65001 > $null
$env:Path = "C:\Program Files\coreutils\bin;$env:Path"
grep.exe -n "繁體中文" "C:\Users\Admin\Documents\example.md"
```

檢查 `cat` 到底是不是 alias：

```powershell
Get-Command cat, cat.exe -ErrorAction SilentlyContinue
```

快速檢查 Coreutils 與中文 round-trip：

```powershell
& "C:\Users\Admin\.codex\skills\coreutils-windows-native-tools\scripts\Test-CoreutilsWindows.ps1"
```

round-trip 是來回測試，意思是把中文寫出去再讀回來，確認沒有壞掉。

## 文件導覽

- [INSTALL.md](INSTALL.md)：安裝方式。
- [docs/SKILL_VS_HOOK.md](docs/SKILL_VS_HOOK.md)：技能與掛鉤的差異。
- [docs/USAGE_SCENARIOS.md](docs/USAGE_SCENARIOS.md)：使用情境。
- [docs/TESTING.md](docs/TESTING.md)：驗證方式。
- [docs/ROLLBACK.md](docs/ROLLBACK.md)：移除與回復方式。
- [線上互動教學](https://lzxpan.github.io/codex-coreutils-shell-guard/)：科技漫畫風互動教學頁，推薦直接點這個連結開啟。
- [docs/index.html](docs/index.html)：互動教學原始檔，適合想看 HTML 原始碼的人。

## 互動教學

推薦直接開線上版：

[開啟互動教學：Codex Coreutils Shell Guard](https://lzxpan.github.io/codex-coreutils-shell-guard/)

如果你已經把 repo 下載到本機，也可以在 repo 根目錄執行：

```powershell
Start-Process ".\docs\index.html"
```

教學頁會用多格科技漫畫說明：

- 亂碼怎麼發生。
- 為什麼 `cat` 和 `cat.exe` 不一定一樣。
- 技能負責什麼。
- 掛鉤負責什麼。
- 怎麼測試自己是否安全。

## 安全邊界

`coreutils-shell-guard` 掛鉤只提醒，不會做下面這些事：

- 不自動改寫命令。
- 不修改 `$PROFILE`。
- 不修改系統 PATH。
- 不隱藏原始錯誤訊息。
- 不取代 `powershell-utf8-guard`。

這些限制是刻意保留的。提醒型掛鉤比較不容易破壞使用者原本的工作環境。
