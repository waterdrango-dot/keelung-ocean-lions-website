# 專案記憶 · 基隆海洋獅子會官網

> 這份檔案記錄「做過一次就不該再踩」的事。
> 每次發現新的坑、新的決定、新的事實，就補進來並 commit，
> 之後任何一個 Claude session 開起來都會自動讀到。

---

## 待確認事項（需會方回覆）

- **創會年數不一致**：首頁 `<title>` 寫「三十年」，
  `data/home.json` 的 hero_title 寫「三十六年」，
  `assets/chrome.js` 寫創會 1991 年（至 2026 年為 35 年）。
  「三十六」可能指第 36 屆而非 36 年。正式對外數字需會方確認後統一。
- **正式網域未定**：目前 SEO 標記暫用 `https://keelung-ocean-lions.netlify.app`。
  確定網域後依 README 的 sed 指令一次替換。
- **LINE 官方帳號**：contact.html 標示「官方帳號建置中」，QR Code 為佔位。
  帳號開通後需更新該區塊。

---

## 已知事實（可直接引用）

- 創會年份：1991
- 所屬：國際獅子會 300A5 區（Lions Clubs International District 300A5）
- 會所地址：202 基隆市中正區義一路 87 號 6 樓之 7（鄰近廟口夜市，火車站步行 8 分鐘）
- 聯絡電話：0928-861093（秘書 江志偉），週一至週五 09:30–17:30
- 會務信箱：keelung.ocean.lions@gmail.com
- 會訓：為海洋盡力，服務無界限

---

## 技術踩過的坑

- **預覽注入碼**：原始壓縮檔中每個 HTML 都含約 7.3KB 的 Claude 預覽注入碼
  （`data-omelette-injected`，含 eval 與對外 postMessage）。已於 2026-09 全數移除。
  日後若從 Claude 預覽環境匯出檔案，**上傳前必須再檢查一次**：
  `grep -l 'omelette' *.html`
- **JS 補 meta 不算數**：`assets/chrome.js` 的 `injectSEO()` 會在載入後補 meta 標籤，
  但 LINE / Facebook 預覽爬蟲不執行 JS。分享預覽要正常，`og:` 必須寫進 HTML 原始碼。
- **SPA fallback 造成 soft 404**：原 `netlify.toml` 有 `/*` → `/index.html` (200) 規則。
  多頁靜態站套用會讓錯誤網址回傳 200 + 首頁，搜尋引擎判定為 soft 404。已移除。
- **README 與實際結構不符**：原 README 描述 `_data/`、`deployment-deck.html`、
  `DEPLOY-GUIDE.md`，這些檔案實際不存在。已重寫。改結構時記得同步更新 README。

---

## 決策紀錄

| 日期 | 決定 | 理由 |
|---|---|---|
| 2026-09-20 | 不引入任何建置工具，維持純靜態 | 維護者是會內委員，必須保持「開檔就能看」 |
| 2026-09-20 | og 標籤寫進 HTML，不依賴 chrome.js | LINE 分享預覽需求 |
| 2026-09-20 | 移除 SPA fallback，改用 Netlify 預設 404 | 避免 soft 404 |
