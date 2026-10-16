---
name: site-content-update
description: 基隆海洋獅子會官網內容更新 SOP。凡要新增或修改網站頁面、發布活動消息、更新歷屆會長／活動相簿／影音紀錄、新增一個頁面、或調整首頁文案時啟用。即使使用者只說「網站加一則活動」「改一下首頁」也要啟用。
---

# 基隆海洋獅子會官網內容更新

## 判斷要走哪一條路

| 情況 | 做法 |
|---|---|
| 只改文字、換照片、發活動消息 | **請委員用後台 `/admin/` 改**，不要動程式碼 |
| 改版面、加區塊、加新頁面 | 改 HTML／CSS，走下面流程 |
| 改導覽列項目 | 一定要動 `assets/chrome.js` |

先確認是哪一種。能用後台解決的不要改 code。

## 新增一個頁面的完整檢查清單

1. **複製最接近的既有頁面**當骨架（例如內容頁複製 `about.html`），
   不要從空白開始，才能沿用版面與 CSS 變數。
2. `<body data-page="<key>">` — key 要新取一個。
3. `<div id="site-nav"></div>` 放在 body 最前面，頁尾不用寫（chrome.js 會補）。
4. `assets/chrome.js` 的 `NAV_PRIMARY` 或 `NAV_PARTICIPATE` 加入同一個 key。
5. head 區塊必備，缺一不可：
   - `<meta charset>`、`<meta name="viewport">`
   - `<title>頁名 · 基隆海洋獅子會</title>`
   - `<meta name="description">`（60–120 字，含「基隆海洋獅子會」）
   - `<link rel="canonical">`
   - `og:type` / `og:site_name` / `og:locale` / `og:title` / `og:description` / `og:url` / `og:image`
   - `twitter:card` / `twitter:title` / `twitter:description` / `twitter:image`
6. 全頁只能有**一個** `<h1>`。
7. 所有 `<img>` 要有有意義的 `alt`（寫照片內容，不要寫「圖片」）。
8. `sitemap.xml` 加入新頁面。
9. 麵包屑 `.breadcrumb` 要更新。

## 照片處理

- 放在 `assets/photos/`，檔名用英文小寫加連字號（例：`service-7.jpg`）。
- 單張控制在 **200KB 以內**，長邊不超過 1600px。
  超過請先壓縮，這個站沒有圖片最佳化流程，原圖直出會拖慢載入。
- 加入前先確認：`ls -la assets/photos/ | sort -k5 -n | tail`

## 完工前必跑的檢核

```bash
# SEO 標籤完整性
for f in *.html; do printf "%-18s desc=%s canonical=%s og=%s viewport=%s h1=%s\n" "$f" \
  "$(grep -c 'name="description"' $f)" "$(grep -c 'rel="canonical"' $f)" \
  "$(grep -c 'og:image' $f)" "$(grep -c 'name="viewport"' $f)" "$(grep -o '<h1' $f|wc -l)"; done

# 圖片缺 alt
grep -o '<img[^>]*>' *.html | grep -v 'alt=' || echo "所有圖片都有 alt ✓"

# 預覽注入碼殘留
grep -l 'omelette' *.html admin/*.html 2>/dev/null || echo "無注入碼殘留 ✓"

# 連結指向不存在的頁面
grep -ohE 'href="[a-z-]+\.html"' *.html | sed 's/href="//;s/"//' | sort -u | \
  while read p; do [ -f "$p" ] || echo "連結失效：$p"; done
```

把檢核結果貼在最後一則訊息裡，再說完成。

## 不要做的事

- 不要引入 npm、框架、bundler。
- 不要改 `admin/config.yml`（會影響委員後台操作），需要改先問會長。
- 不要推測年份、屆數、人名、金額，查不到就標明「需會方提供」。
