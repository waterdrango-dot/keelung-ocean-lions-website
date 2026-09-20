# 基隆海洋獅子會官方網站

> 30 年公益 · 一片海洋

## 專案結構

```
.
├── index.html              # 首頁
├── about.html              # 關於我們
├── presidents.html         # 歷屆會長
├── service.html            # 公益實踐
├── media.html              # 影音紀錄
├── gallery.html            # 活動相簿
├── join.html               # 加入我們
├── contact.html            # 聯絡我們
├── deployment-deck.html    # 部署計畫提案 (簡報)
├── assets/
│   ├── styles.css          # 全站樣式
│   ├── chrome.js           # 共用導覽 + 頁尾
│   └── uploads/            # CMS 上傳的圖片
├── admin/
│   ├── index.html          # Decap CMS 入口
│   └── config.yml          # CMS 欄位設定
├── _data/
│   ├── site.yml            # 聯絡資訊
│   ├── homepage.yml        # 首頁文案
│   ├── presidents/         # 會長資料 (CMS 自動產生)
│   ├── ambassadors/        # 大使資料
│   ├── activities/         # 活動資料
│   ├── videos/             # 影音資料
│   └── press/              # 媒體報導
├── netlify.toml            # Netlify 部署設定
└── DEPLOY-GUIDE.md         # 部署上線完整指南
```

## 快速開始

請閱讀 **[DEPLOY-GUIDE.md](./DEPLOY-GUIDE.md)** 進行部署。

## 本機預覽

直接用瀏覽器開啟 `index.html` 即可。

## 後台網址

部署完成後：`https://[your-site].netlify.app/admin/`
