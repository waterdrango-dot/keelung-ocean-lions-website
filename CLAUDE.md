# CLAUDE.md

@tigeros/core/CLAUDE.core.md

## 本 repo 是什麼

基隆海洋獅子會（KOL）官網。靜態 HTML 站，Netlify 部署，後台用 Netlify CMS（`admin/config.yml`）。

同時是 **TigerOS 目前的落腳處**——`tigeros/` 目錄是三個事業體共用的 harness 核心，
設計成可攜，之後會掛載到 `chengbao-erp` 等 repo。改 `tigeros/` 時請記得它不只服務這個站。

## ⚠️ 本 repo 的特殊狀況

版控裡目前**只有一個 `keelung-ocean-lions-website.zip`**（3.7MB），網站原始碼沒有解開進 git。

後果：無法 diff、無法 code review、無法追改動歷史、Netlify 也無法直接從 repo 建置。

**解壓進版控屬 B 級**（會產生 60+ 檔案、3.7MB 的大 diff，且改變 repo 性質）——
需江董首肯後才執行，不要自行動手。

## 網站結構（來自 zip 內容）

```
index.html about.html agm.html contact.html donate.html gallery.html
history.html join.html media.html members.html presidents.html
register.html service.html
admin/          Netlify CMS 後台
data/home.json  首頁內容
assets/         styles.css chrome.js lions/ photos/
netlify.toml    部署設定
```

文件：`README.md`、`DEPLOY-SOP.md`、`ADMIN-USERS-GUIDE.md`（皆在 zip 內）

## 改動原則

- 這是**對外正式站**。內容改動前先確認，不要直接動線上版。
- 獅子會會員姓名、電話、職務屬個資，依核心憲法第 5 條不得寫進 commit 或公開檔案。
- 改 `tigeros/` 後務必跑 `sh tigeros/hooks/test-guard.sh`。
