# 基隆海洋獅子會官網 · 工作規則

## 這個 repo 是什麼
純靜態多頁網站（13 個 HTML），無建置流程，直接部署到 Netlify。
內容由委員透過 Decap CMS 後台（`/admin/`）維護，CMS 寫回 `data/` 與各 HTML。

## 語言與產出
- 全部以繁體中文溝通與產出，語氣專業簡潔。
- 對外文案（網站可見文字）用正式但溫暖的語氣，避免行銷腔與誇大詞。
- 提供修改時給完整可直接貼上的內容，不要只給「大概這樣改」。

## 技術約定
- **不引入建置工具**（不要 npm、bundler、框架）。這個站的維護者是會內委員，
  必須維持「用瀏覽器開 index.html 就能看」的狀態。
- 樣式一律寫在 `assets/styles.css` 或頁面內 `<style>`，沿用既有 CSS 變數
  （`--ocean-deep`、`--lion-gold`、`--sea-ink`、`--s-*` 間距等），不要另立一套。
- 導覽列與頁尾由 `assets/chrome.js` 注入，頁面中只放 `<div id="site-nav"></div>`。
  新增頁面時必須同步更新 chrome.js 的 `NAV_PRIMARY` 或 `NAV_PARTICIPATE`。
- 每個 `<body>` 要有 `data-page="<key>"`，key 需與 chrome.js 導覽項目的 key 一致，
  導覽列才會正確標示目前頁面。

## SEO 規則（重要）
- `og:` 與 `twitter:` 標籤**必須寫在 HTML 原始碼**。chrome.js 雖會在載入後補，
  但 LINE、Facebook 的預覽爬蟲不執行 JavaScript，靠 JS 補的標籤不會出現在分享預覽。
- 新增頁面時必檢查：`<title>`、`meta description`、`canonical`、`og:*`、`viewport`、
  唯一一個 `<h1>`、所有 `<img>` 有 `alt`。
- 新增頁面後同步加入 `sitemap.xml`。
- 網域寫死在 HTML 中，換網域請用 README 裡的 sed 指令一次替換。

## 資料正確性
- 網站上的年份、屆數、金額、人名、職稱**不得推測**。
  查不到就在回覆中標明「查無，需要會方提供」，不要自行填入看起來合理的數字。
- 已知可引用的事實：1991 年創會、國際獅子會 300A5 區、
  會所 202 基隆市中正區義一路 87 號 6 樓之 7、電話 0928-861093、
  會務信箱 keelung.ocean.lions@gmail.com。

## 分支與提交
- 從 `main` 開分支，分支名 `claude/<主題>`。
- commit message 用繁體中文，說明「為什麼改」而非只寫「改了什麼」。
- 每條任務開一個 draft PR。

## 必須先問過才能做
- 刪除既有頁面或照片。
- 更動 `admin/config.yml`（會影響委員後台操作）。
- 更動 Netlify Identity / Git Gateway 相關設定。
- 任何會對外發布的動作（正式部署、對外公告）。

## 遇到缺料
需要的資料、圖片、權限拿不到時，第一則訊息就明講缺什麼並停下。
不要用假資料、不要 placeholder 充數、不要猜。
