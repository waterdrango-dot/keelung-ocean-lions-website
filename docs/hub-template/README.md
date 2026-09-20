# 中樞 repo 範本 · 使用說明

## 這是什麼

Claude Code 的 **Projects** 功能（一個總管 + 多條平行執行緒）目前是 Pro/Max 分批開放的 Beta。
沒開通也能自己做出八成效果 —— 把 Projects 的「設定」變成 GitHub repo 裡的實體檔案，
每開一個雲端 session 指向這個 repo，就自動載入同一份背景，不用每次重講。

| Projects 功能 | 自建替代品 |
|---|---|
| Project instructions | repo 根目錄 `CLAUDE.md`（session 啟動自動讀） |
| Project memory | repo 根目錄 `MEMORY.md`（要記的事叫 Claude 寫進去並 commit） |
| 共用 Skills | `.claude/skills/<名稱>/SKILL.md`（自動載入） |
| Library 檔案庫 | Google Drive 資料夾（用 Drive 連接器讀） |
| Threads 平行跑 | 自己在 claude.ai/code 同時開多個 cloud session |
| Overview 面板 | 自己看 session 列表 |

**拿不到的只有「自動派工」和「一眼看全局」，工作本身照樣做得完。**

## 怎麼用這份範本

1. 在 GitHub 開一個新的 private repo，例如 `chengbao-ops`。
2. 把 `CLAUDE.md.sample` 複製成該 repo 的 `CLAUDE.md`，依實際狀況修改。
3. 把 `MEMORY.md.sample` 複製成 `MEMORY.md`，一開始可以只留標題，之後累積。
4. 建 `.claude/skills/` 資料夾，把現有的 skill 一個一個搬進去
   （格式參考本 repo 的 `.claude/skills/_template/SKILL.md`）。
5. 到 <https://github.com/apps/claude> 把 Claude GitHub App 裝到這個新 repo 上。
6. 之後在 claude.ai/code 開 session 時選這個 repo 即可。

## 建議的目錄結構

```
chengbao-ops/
├── CLAUDE.md                  # 常規規則（等同 Project instructions）
├── MEMORY.md                  # 累積的決定與踩過的坑
├── .claude/
│   └── skills/
│       ├── _template/SKILL.md
│       ├── monthly-pnl/SKILL.md
│       ├── payment-reconciliation/SKILL.md
│       └── homecare-contract/SKILL.md
└── docs/
    ├── 法規/                  # 長照 2.0 給付規定、評鑑基準
    ├── SOP/                   # 機構內部流程
    └── 範本/                  # 契約、照顧計畫、公文範本
```

## 平行作業的實際操作

要同時跑三件事時，在 claude.ai/code 開三個 session，都指向 `chengbao-ops`：

- session A：「比對 10 月三方帳」
- session B：「檢核 11 月排班合規」
- session C：「更新照護計畫範本」

三個都會自動讀到同一份 `CLAUDE.md` 和 `MEMORY.md`，不用重講背景。
關掉電腦它們繼續跑，回來一個一個看結果。

## 重要限制：哪些工作搬不上雲端

雲端 session 跑在隔離沙箱裡，**摸不到本機的東西**。以下必須留在本機執行：

| 工作 | 為何搬不上去 |
|---|---|
| Chrome MCP 登入富邦行動辦公室抓業績 | 需要本機瀏覽器與登入狀態 |
| 桌面版 LINE 讀群組、LINE OA 日報 | 需要本機 LINE 應用程式 |
| 仁寶 i 照護系統抓個案資料 | 需要本機登入 |
| NAS 上的會計師檔案 | 除非先同步到 Google Drive |
| 地端 Codex 覆核 | 本機 MCP 伺服器 |

**可以搬上雲端的**：Gmail、Google Drive、Gamma 這些帳號層級的連接器，每個 session 都能用。

實務分工：**本機負責抓取，雲端負責分析與產出。**

## 額度提醒

每條平行 session 都是完整的 Claude Code session，同時跑五條就是五倍消耗，
吃的是同一份方案額度。建議：

- 一次跑 2–3 條就好
- 不需要最強模型的任務，開 session 時選 Sonnet
- 先跑一週，再決定要不要擴大
