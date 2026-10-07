# TigerOS Hooks

把治理規則從「文件約束」變成「程式強制」。

| 檔案 | 類型 | 作用 |
|---|---|---|
| `startup-briefing.sh` | SessionStart | 開場注入治理摘要與當前未解風險，解決「每次都要重講規矩」 |
| `guard-bash.sh` | PreToolUse (Bash) | 攔截違反紅線的指令，exit 2 擋下並把理由回饋給模型 |
| `skill-router.sh` | UserPromptSubmit | 規則評分後明示提醒該用哪個技能；並偵測雲端 session 警告本機依賴 |
| `test-guard.sh` | 測試 | guard 的回歸測試，22 項 |
| `test-router.sh` | 測試 | router 的回歸測試，17 項 |

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

## ⚠️ 這是縱深防禦，不是安全邊界

**guard 做字串比對，可以被繞過。** 不要把它當成不可逾越的防線。

擋不住的情況：
- 包一層腳本：`./my-deploy.sh` 內含禁令指令 → 看不到
- 換等效寫法：`npm run db:push` 實際跑 prisma → 沒比對到
- 變體參數：長短旗標、參數順序調換，未必每種都涵蓋

擋得住的情況（也正是實際出事的那種）：**順手、憑記憶、直接打出來的指令**。
2026-05-04 的停機就是這樣發生的——有人直接下 `docker compose stop`。
guard 的價值在於把「靠記性」換成「靠攔截」，不在於防範蓄意繞過。

誤判：heredoc 內容會被剝除（寫檔 ≠ 執行），但禁令字串若出現在一般引號裡
（如 `echo "docker compose down"`）仍會誤擋。此時改用 Write 工具寫檔，或暫時開逃生門。

同理，`settings.json` 的 `permissions.deny` 也是前綴比對，同樣可被變體繞過。
它降低誤觸機率，不構成隔離。真正的隔離要靠帳號權限與網路層。

## 技能路由（skill-router.sh）

解決「技能裝了卻不啟動」：不再只靠模型讀 `description` 自行判斷，
改由 `tigeros/skills/skill-rules.json` 的關鍵字與意圖規則評分，命中就把提示注入 context。

規則檔每個技能標 `runtime`：

| 值 | 意義 |
|---|---|
| `local` | 需本機 Chrome／桌面版 LINE／地端 Codex／NAS |
| `cloud` | 雲端可執行 |
| `any` | 純文書，兩邊皆可 |

在雲端 session（`$CLAUDE_CODE_REMOTE=true`）命中 `local` 技能時會先警告跑不動，
避免排程每天定時失敗一次。

## 改動後務必跑測試

```bash
sh tigeros/hooks/test-guard.sh    # 22 項
sh tigeros/hooks/test-router.sh   # 17 項
```
