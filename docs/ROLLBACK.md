# 回復方式

這份 repo 的掛鉤只提醒，不會改 `$PROFILE`、不會改系統 PATH、也不會改寫命令。

如果你要移除它，可以照下面做。

## 移除技能

```powershell
Remove-Item -LiteralPath "C:\Users\Admin\.codex\skills\coreutils-windows-native-tools" -Recurse
```

刪除前請確認路徑正確。

## 移除 plugin

```powershell
Remove-Item -LiteralPath "C:\Users\Admin\plugins\coreutils-shell-guard" -Recurse
```

## 移除 marketplace 註冊

打開：

```text
C:\Users\Admin\.agents\plugins\marketplace.json
```

刪除 `coreutils-shell-guard` 相關項目。

如果你是透過 `codex plugin marketplace add C:\Users\Admin` 註冊，需要再檢查：

```text
C:\Users\Admin\.codex\config.toml
```

移除或停用對應 marketplace / plugin 設定。

## 重開 Codex

移除後重開 Codex，掛鉤設定頁應該不再顯示 `coreutils-shell-guard`。

## 不需要回復的項目

這個 plugin 預設不改：

- `$PROFILE`
- 系統 PATH
- Windows 系統語系
- `powershell-utf8-guard`
- 其他全域技能
