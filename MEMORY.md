# 專案記憶 · 基隆海洋獅子會官網

> 這份檔案記錄「做過一次就不該再踩」的事。
> 每次發現新的坑、新的決定、新的事實，就補進來並 commit，
> 之後任何一個 Claude session 開起來都會自動讀到。

---

## 待確認事項（需會方回覆）

- **現任屆次敘述不一致**：`index.html`、`members.html`、`data/home.json`
  寫第 36 屆現任會長江志偉（2026–2027）；但 `history.html` 時間軸仍把
  第 35 屆（張眾佳，2025–2026）標記為 `CURRENT`，且文中寫「現任理事長張眾佳、
  第一副會長兼秘書江志偉」；`about.html` 時間軸最後一筆停在第 35 屆。
  需會方確認現任會長與職稱後，統一 history.html 與 about.html。
  （屆數與職稱屬不得推測項目，未自行更動。）
- **文字疑似漏字**：`about.html` 第 602 行「第 35 屆會長張眾佳職」，
  推測應為「張眾佳就職」，待會方確認。
- **LINE 官方帳號**：contact.html 標示「官方帳號建置中」，QR Code 為佔位。
  帳號開通後需更新該區塊。

---

## 已拍板事項

- **創會年數：35 年**（2026-09-20 會方確認）。
  1991 年創會，對外一律寫「三十五年」或「35 年」。
  例外：`about.html` 第 595 行《授證 30 週年紀念特刊》與第 843 行
  「本會 1991–2021 三十年國際公益足蹟」為歷史事件的正確敘述，不得改成三十五年。
- **正式網域：`https://keelung-ocean-lions.netlify.app`**（2026-09-20 確認）。
  依據為 `admin/config.yml` 既有的 `site_url` 與 `display_url` 設定，
  與 SEO 標記一致。日後若改自訂網域，依 README 的 sed 指令替換，
  並**同步改 `admin/config.yml` 的這兩個欄位**（README 的指令不含該檔）。

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
