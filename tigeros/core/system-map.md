# TigerOS 系統地圖

> 盤點日期：2026-09-20。本檔是「現況」，不是「理想」。改動系統後請同步更新。

## 三個事業體

| 代號 | 事業體 | 說明 |
|---|---|---|
| `CB` | 誠寶有限公司（居家長照） | 統編 55943790；附設基隆市私立誠寶居家長照機構 |
| `BJ` | 富邦人壽 邦躍通訊處 C1160 | 業務團隊經營管理 |
| `KOL` | 基隆海洋獅子會 | 社團官網與會務 |

## Repo 地圖

| Repo | 角色 | 狀態 |
|---|---|---|
| `chengbao-erp` | **ERP 主線**：資料庫 schema、API、後台、CI、治理文件 | 活躍 |
| `chengbao-ops-platform` | 同系統舊快照（2026-03 停滯） | ⚠️ 應歸檔 |
| `chengbao-governance` | 治理母規則 | 低頻 |
| `chengbao-skills` | 全域 skills 公開子集 | ⚠️ 格式待修 |
| `chengbao-ai-training` | 知識萃取；目前唯一有 CLAUDE.md 的 repo | 低頻 |
| `keelung-ocean-lions-website` | 獅子會官網（TigerOS 目前落腳處） | 本 repo |

## 生產環境

| 項目 | 內容 |
|---|---|
| 資料庫 | PostgreSQL 16 + pgvector（1536 維），Prisma ORM |
| 佇列 / 快取 | Redis + BullMQ |
| 後端 / 前端 | NestJS + Next.js 14，Turborepo + pnpm |
| 部署 | NAS `/volume2/docker/chengbao-ops/`，Docker Compose |
| 部署腳本 | `deploy-api.sh`（唯一允許；含 flock 防併發） |
| 對外網域 | `www.care365.com.tw` / webhook `api.care365.com.tw`（CF Named Tunnel） |
| LINE OA | 雙帳號：案主端（查帳單）＋ 管理部端（查薪資） |

## 資料庫 schema 現況

`chengbao-erp` 為唯一 schema 來源（72 models），是 `chengbao-ops-platform`（61 models）的**嚴格超集**，未刪除任何 model。

erp 獨有的 11 個 model：

- 會計總帳：`ChartOfAccount`、`JournalVoucher`、`JournalEntryLine`
- 人資：`HrEmployeeProfile`、`HrAttendanceMonthly`、`HrPayrollRunCheck`、`HrInsuranceSnapshot`、`HrLeaveCycle`、`HrBenefitEvent`、`HrBenefitRuleVersion`、`HrEmploymentEvent`

⚠️ **未解風險**：`chengbao-ops-platform` 沒有 `prisma/migrations/`，該版本可能是用 `prisma db push` 直接推上生產庫。`chengbao-erp` 改用 migrations 管理（目前 2 筆）。若線上庫 `_prisma_migrations` 表基線對不上，`prisma migrate deploy` 會失敗。

**碰任何 schema 前，必須先在 NAS 上確認：**

```sql
SELECT migration_name, finished_at FROM _prisma_migrations ORDER BY finished_at;
```

## 已知文件不一致（待江董裁示，勿自行修改）

治理文件之間互相矛盾，AI 無法自行判定何者為真：

| 項目 | 說法 A | 說法 B |
|---|---|---|
| 服務地區 | 治理母規則：桃園 + 新北 | 機構登記與 skills：基隆 |
| 資料庫選型 | ai-training CLAUDE.md §9：Firebase 優先 | 實際生產：PostgreSQL 16 |
| 決策者姓名 | 治理母規則 §5.1 標註之姓名 | 各 skill 內另有稱謂 |

處理原則：**一律以「江董」稱呼決策者**；上述三項在江董明文確認前，不得寫入任何自動化流程或對外文件。
