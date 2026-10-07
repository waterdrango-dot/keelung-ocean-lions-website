# 排程目錄（Routines Catalog）

> 盤點日期 2026-09-20。**現況：5 個每日排程技能，0 個排程掛載。**

## 為什麼 `/loop` 不能用來做每日排程

| 限制 | 後果 |
|---|---|
| 必須手動輸入 `/loop` | 不會自己啟動 |
| 間隔上限 1 小時（60–3600 秒） | **設不到每日 07:00** |
| 跟著 session 生命週期 | 關視窗／容器回收就停 |

`/loop` 只適合「盯著一件事跑完」（等 CI、等部署）。每日例行**一律用 Routine 或本機排程器**。

## 雲端 vs 本機判定

Routine 在**雲端全新容器**執行，碰不到本機 Chrome、桌面版 LINE、地端 Codex、NAS。
依資料來源決定放哪裡：

| 技能 | 設計時間 | 資料來源 | 可上雲？ | 建議 |
|---|---|---|---|---|
| `cb-schedule-reminder-today` | 每日早晨 | 排班（來源待確認） | ⚠️ 待確認 | 若走 ERP API → 雲端；若走仁寶網頁 → 本機 |
| `cb-schedule-reminder-tomorrow` | 每日晚間 | 同上 | ⚠️ 待確認 | 同上 |
| `cb-schedule-reminder-weekly` | 每週一早晨 | 同上 | ⚠️ 待確認 | 同上 |
| `chengbao-daily-bank-reconcile` | 每日 08:00 | 瀏覽器＋地端 Codex | ❌ | **本機** |
| `cb-lineoa-daily-report` | 每日 | LINE OA Manager 網頁 | ❌ | **本機** |
| `Weekly keelung competitor scan` | 每週三 12:00 | 公開網路 | ✅ | 已掛載 |

> 已掛載的那支建立於 2026-09-16 12:14（台北），剛好錯過當天 12:00，首次執行為 09-23。**非故障。**

## Cron 對照（Routine 用 UTC，台北 = UTC+8）

| 想要的台北時間 | cron（UTC） | 備註 |
|---|---|---|
| 每日 07:00 | `0 23 * * *` | 前一天 23:00 UTC |
| 每日 08:00 | `0 0 * * *` | |
| 每日 20:00 | `0 12 * * *` | |
| 每週一 08:00 | `0 0 * * 1` | |
| 每週三 12:00 | `0 4 * * 3` | |

跨午夜會位移星期，務必連星期欄一起換算。

## 本機排程範本（Windows 工作排程器）

```
程式：claude
引數：-p "/cb-schedule-reminder-today"
起始於：C:\Users\OEM\Downloads
觸發：每日 07:00
```

⚠️ **不要加 `--dangerously-skip-permissions`**。治理母規則第 9 條明訂 bypass permissions 預設關閉。
改用 `.claude/settings.json` 的 `permissions.allow` 精準放行所需工具（範本見 `tigeros/settings.json.example`）。

## 掛載 Routine 前的檢查表

- [ ] 資料來源確認不依賴本機（否則改本機排程）
- [ ] 流程中**對外發訊息**的步驟已取得江董明文授權（C 級）
- [ ] cron 已換算成 UTC
- [ ] 失敗時的通知對象已設定
- [ ] 先手動跑一次驗證成功，再掛排程

## ⛔ 尚未掛載的原因

這 5 支技能會**主動發 LINE 訊息**給江董與「誠寶居服部」群組。
依治理母規則，對外發訊息屬 **C 級**，需明文授權。
**在江董逐項確認前，TigerOS 不自動建立這些 Routine。**
