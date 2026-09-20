# 基隆海洋獅子會官方網站

> 自 1991 年創會 · 國際獅子會 300A5 區 · 為海洋盡力，服務無界限

純靜態網站（無需建置流程），搭配 Decap CMS 後台，部署於 Netlify。

## 專案結構

```
.
├── index.html              # 首頁
├── about.html              # 關於我們
├── presidents.html         # 歷屆會長
├── service.html            # 公益實踐
├── history.html            # 會史紀要
├── media.html              # 影音紀錄
├── gallery.html            # 活動相簿
├── join.html               # 加入我們
├── donate.html             # 公益捐款
├── register.html           # 活動報名
├── agm.html                # 年度大會
├── members.html            # 會員專區
├── contact.html            # 聯絡我們
├── assets/
│   ├── styles.css          # 全站樣式
│   ├── chrome.js           # 共用導覽列 + 頁尾 + 行動選單
│   ├── lions/              # 獅子會識別圖像
│   └── photos/             # 活動照片
├── admin/
│   ├── index.html          # Decap CMS 入口
│   └── config.yml          # CMS 欄位設定
├── data/
│   └── home.json           # 首頁文案（CMS 寫入）
├── robots.txt              # 搜尋引擎索引規則
├── sitemap.xml             # 網站地圖
├── netlify.toml            # Netlify 部署設定
├── DEPLOY-SOP.md           # 三分鐘部署 SOP
└── ADMIN-USERS-GUIDE.md    # 委員後台使用說明
```

## 本機預覽

直接用瀏覽器開啟 `index.html` 即可，不需要安裝任何東西。

若要讓 `admin/` 後台在本機正常運作，需以簡易伺服器啟動：

```bash
python3 -m http.server 8000
# 瀏覽器開 http://localhost:8000
```

## 部署

請參考 **[DEPLOY-SOP.md](./DEPLOY-SOP.md)**。後台網址為 `https://[站名].netlify.app/admin/`，
委員使用說明見 **[ADMIN-USERS-GUIDE.md](./ADMIN-USERS-GUIDE.md)**。

## 更換正式網域

正式網址為 `https://keelung-ocean-lions.netlify.app`，
同時寫在各頁 SEO 標記、`robots.txt`、`sitemap.xml` 與 `admin/config.yml`
（CMS 的 `site_url` / `display_url`）。

若日後改用自訂網域，執行以下指令一次換掉全部：

```bash
OLD="https://keelung-ocean-lions.netlify.app"
NEW="https://你的新網域"
sed -i "s|$OLD|$NEW|g" *.html robots.txt sitemap.xml admin/config.yml
```

漏掉 `admin/config.yml` 會讓後台的「檢視網站」連結指向舊網址。

## 維護注意事項

- `assets/chrome.js` 會在頁面載入後補上缺漏的 meta 標籤，但 **LINE、Facebook 的預覽爬蟲不執行 JavaScript**，
  因此分享預覽所需的 `og:` 標籤必須寫在 HTML 原始碼裡，不能只靠 chrome.js 補。
- 新增頁面時，記得同步更新 `sitemap.xml` 與 `assets/chrome.js` 的導覽清單。
