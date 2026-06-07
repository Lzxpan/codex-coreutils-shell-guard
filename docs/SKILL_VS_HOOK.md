# 技能與掛鉤的差異

## 一句話

技能教 Codex 怎麼做。掛鉤提醒 Codex 什麼時候要小心。

## 技能是什麼

技能是放在 `SKILL.md` 裡的說明書。Codex 遇到相關任務時，可以讀技能，照著裡面的規則處理。

`coreutils-windows-native-tools` 這個技能會告訴 Codex：

- 在 PowerShell 裡要優先寫 `grep.exe`、`cat.exe`、`wc.exe`、`xargs.exe`。
- 不要把 `cat` 當成一定是 Coreutils 的 `cat.exe`。
- 處理中文、Unicode、JSON、Markdown、YAML、log 或重導向時，要先用 UTF-8 防護。
- Coreutils 找不到時，先檢查 `C:\Program Files\coreutils\bin`。

## 掛鉤是什麼

掛鉤（原詞：hook，意思是 Codex 在特定時機自動跑的小檢查）不是完整工作流程。

`coreutils-shell-guard` 目前有兩種掛鉤：

| 掛鉤 | 觸發時間 | 作用 |
|---|---|---|
| `SessionStart` | Codex 工作階段開始時 | 提醒 Windows shell、UTF-8 與 Coreutils 狀態。 |
| `PostToolUse` | shell 工具執行後 | 檢查剛剛的命令是否可能有 alias、中文、重導向或管線風險。 |

## 為什麼掛鉤不自動修

自動修看起來方便，但風險比較高。

例如把 `cat` 自動改成 `cat.exe`，可能在某些情境改變原本行為。把 UTF-8 preamble 自動插入每個命令，也可能讓除錯時看不清楚原始環境。

所以這個掛鉤只提醒，不改寫。

## 正確搭配方式

1. 掛鉤提醒：「這個命令可能有風險。」
2. Codex 讀技能：「該怎麼穩定處理。」
3. Codex 執行命令：「套 UTF-8 防護，並用明確 `.exe` 名稱。」
4. 回報結果：「說清楚哪些是已驗證，哪些是 `not_verified`。」
