# TigerOS Hooks

把治理規則從「文件約束」變成「程式強制」。

| 檔案 | 類型 | 作用 |
|---|---|---|
| `session-start.sh` | SessionStart | 開場注入治理摘要與當前未解風險，解決「每次都要重講規矩」 |
| `guard-bash.sh` | PreToolUse (Bash) | 攔截違反紅線的指令，exit 2 擋下並把理由回饋給模型 |
| `test-guard.sh` | 測試 | guard 的回歸測試，22 項 |

## 安裝

由 `tigeros/install.sh` 自動寫入 `.claude/settings.json`。手動安裝見 `tigeros/settings.json.example`。

## guard 攔截清單

| 攔截 | 依據 |
|---|---|
| `docker compose down / stop / restart / build / up --build` | 2026-05-04 造成 23 分鐘停機 |
| `prisma db push` / `migrate deploy` | 線上庫 migration 基線未確認 |
| `prisma migrate reset` | 會清空資料庫，D 級 |
| `--no-verify` | 治理母規則絕對禁令 |
| 對 `main` / `master` force push | 治理母規則絕對禁令 |

## 逃生門

僅限江董明文授權後使用，設在 `.claude/settings.json` 的 `env` 區塊：

```json
{ "env": { "TIGEROS_ALLOW_SCHEMA": "1" } }
```

- `TIGEROS_ALLOW_DOCKER=1` — 放行 docker 破壞性指令
- `TIGEROS_ALLOW_SCHEMA=1` — 放行 prisma 生產 schema 指令

用完立刻移除。

## 已知限制

guard 做字串比對。heredoc 內容會被剝除（寫檔 ≠ 執行），但禁令字串若出現在一般引號裡
（如 `echo "docker compose down"`）仍會誤擋。此時改用 Write 工具寫檔，或暫時開逃生門。

## 改動後務必跑測試

```bash
sh tigeros/hooks/test-guard.sh
```
