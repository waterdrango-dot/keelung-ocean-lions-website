# TigerOS

江董三個事業體共用的 AI 工作台核心（harness）。**可攜**：一份規則，掛載到任何 repo。

> v0.2.0 · 建立於 2026-09-20 · 盤點依據見 `core/system-map.md`

## 解決什麼問題

盤點三個事業體、六個 repo 後發現的四個破口：

| 破口 | 現況 | TigerOS 的處理 |
|---|---|---|
| 規則讀不到 | 治理母規則放 NAS 與本機，GitHub 上的 repo 讀不到。6 個 repo 只有 1 個有 CLAUDE.md | `core/CLAUDE.core.md` 進版控，各 repo 用 `@` 匯入 |
| 規矩只靠自律 | 部署禁令寫在 `CODEX_NOTICE.md`，但 2026-05-04 仍發生 23 分鐘停機 | `hooks/guard-bash.sh` 直接攔截，不再靠記性 |
| 技能不會載入 | `chengbao-skills` 9 個 flat `.md` 格式錯誤，實際從未生效 | `skills/validate-skills.sh` 驗證＋`_template/` 範本 |
| 技能載入了也不觸發 | 只靠模型讀 `description` 自行判斷，不確定 | `hooks/skill-router.sh` 規則評分後明示提醒 |
| 排程跑在雲端卻要本機 | 需 Chrome／桌面 LINE／地端 Codex 的技能在雲端必定失敗 | router 偵測 `$CLAUDE_CODE_REMOTE` 先警告 |
| 排程全手動 | 5 個「每日」技能，0 個排程 | `routines/catalog.md` 規格與雲端／本機判定 |

## 結構

```
tigeros/
├── core/
│   ├── CLAUDE.core.md       共用憲法（各 repo 以 @ 匯入）
│   ├── authority-levels.md  A/B/C/D 分級、六條硬停、禁令
│   ├── system-map.md        三事業體／repo／生產環境／已知風險
│   └── naming.md            命名規範
├── hooks/
│   ├── session-start.sh     開場注入治理摘要＋執行環境（雲端／本機）
│   ├── guard-bash.sh        攔截違反紅線的指令
│   ├── skill-router.sh      技能路由＋雲端本機依賴警告
│   ├── test-guard.sh        回歸測試（22 項）
│   ├── test-router.sh       回歸測試（17 項）
│   └── README.md
├── skills/
│   ├── skill-rules.json     技能路由規則（關鍵字／意圖／runtime）
│   ├── validate-skills.sh   skill 格式驗證器
│   ├── _template/SKILL.md   正確格式範本
│   └── README.md
├── routines/catalog.md      排程目錄與雲端／本機判定
├── settings.json.example    權限 allowlist ＋ hooks 設定
└── install.sh               掛載到其他 repo
```

## 掛載到其他 repo

```bash
sh tigeros/install.sh /path/to/chengbao-erp
cd /path/to/chengbao-erp
git add tigeros .claude CLAUDE.md
git commit -m "chore(tigeros): 掛載 TigerOS harness"
```

腳本會複製 `tigeros/`、寫入 `.claude/settings.json`、建立或補上 `CLAUDE.md` 的匯入行，
最後實際跑一次 hooks 驗證有效。既有檔案預設不覆蓋，要覆蓋加 `--force`。

## 驗證

```bash
sh tigeros/hooks/test-guard.sh                    # 22 項
sh tigeros/hooks/test-router.sh                   # 17 項
sh tigeros/skills/validate-skills.sh ~/.claude/skills
sh tigeros/hooks/session-start.sh                 # 看開場注入什麼
```

## 設計取捨

攔截層是**縱深防禦，不是安全邊界**——字串比對擋得住「順手打出來」的危險指令
（2026-05-04 停機正是這種），擋不住蓄意繞過（包一層腳本、換等效指令）。
細節見 `hooks/README.md`。

技能路由用 python3 而非 Node.js，因為守衛已依賴 python3，不額外增加執行環境需求。

## 待辦（依優先序）

1. **確認線上庫 migration 基線** — 阻塞所有 schema work，見 `core/system-map.md`
2. 宣告 `chengbao-erp` 為唯一 schema 來源，歸檔 `chengbao-ops-platform`
3. 掛載 TigerOS 到 `chengbao-erp`
4. 修正 `chengbao-skills` 9 個 skill 格式
5. 依 `routines/catalog.md` 逐項確認後掛排程（需 C 級授權）
6. 釐清 `core/system-map.md` 列的 3 處文件矛盾

## 邊界

TigerOS 是**規則與工具層**，不含任何真實個資、憑證、金額。
資料留在 NAS 與 ERP 資料庫，規則留在這裡。
