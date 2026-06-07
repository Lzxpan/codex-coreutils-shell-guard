# 使用情境

## 情境一：搜尋中文 Markdown

問題：

```powershell
grep "繁體中文" README.md
```

風險：

- `grep` 可能找不到，或不是預期的 Coreutils。
- 中文可能受到 PowerShell 編碼影響。

建議：

```powershell
$utf8NoBom = [System.Text.UTF8Encoding]::new($false)
[Console]::InputEncoding = $utf8NoBom
[Console]::OutputEncoding = $utf8NoBom
$OutputEncoding = $utf8NoBom
chcp.com 65001 > $null
$env:Path = "C:\Program Files\coreutils\bin;$env:Path"
grep.exe -n "繁體中文" README.md
```

## 情境二：`cat` 看起來能用，但其實不是 `cat.exe`

問題：

```powershell
cat file.txt
```

在 PowerShell 裡，`cat` 通常是 `Get-Content` 的 alias。alias 是捷徑名稱，不一定等於你以為的外部程式。

檢查：

```powershell
Get-Command cat, cat.exe -ErrorAction SilentlyContinue
```

建議：

```powershell
cat.exe file.txt
```

## 情境三：輸出到檔案後中文壞掉

問題：

```powershell
cat file.txt > out.txt
```

風險：

- `>` 是重導向，意思是把輸出寫進檔案。
- 如果編碼沒有先設好，中文可能變亂碼。

建議：

```powershell
$utf8NoBom = [System.Text.UTF8Encoding]::new($false)
[Console]::InputEncoding = $utf8NoBom
[Console]::OutputEncoding = $utf8NoBom
$OutputEncoding = $utf8NoBom
chcp.com 65001 > $null
Get-Content -LiteralPath .\file.txt -Encoding utf8 | Set-Content -LiteralPath .\out.txt -Encoding utf8
```

## 情境四：計算搜尋結果行數

目標：找出含 `繁體中文` 的行數。

```powershell
$utf8NoBom = [System.Text.UTF8Encoding]::new($false)
[Console]::InputEncoding = $utf8NoBom
[Console]::OutputEncoding = $utf8NoBom
$OutputEncoding = $utf8NoBom
chcp.com 65001 > $null
$env:Path = "C:\Program Files\coreutils\bin;$env:Path"
cat.exe file.txt | grep.exe "繁體中文" | wc.exe -l
```

預期輸出：

```text
1
```

## 情境五：Codex 自動提醒

如果 `coreutils-shell-guard` 已安裝並被信任，Codex 在執行 shell 後可能提醒：

```text
[coreutils-shell-guard] PowerShell alias risk...
```

這不是錯誤。它是在提醒你：剛剛的命令可能因為 alias、管線或編碼而不穩。
