# 三分鐘部署 SOP

**對象：江志偉 會長**
**目的：把這個資料夾上傳到 Netlify,讓網站上線、後台可登入。**

---

## 第 1 步 · 註冊 Netlify 免費帳號(用 Gmail)

1. 開瀏覽器,前往 **https://app.netlify.com/signup**
2. 點「**Sign up with Google**」,用平常用的 Gmail 登入
3. 同意授權即可,**完全免費,不需信用卡**

---

## 第 2 步 · 拖曳整個專案資料夾上去

1. 登入後進入 Netlify 首頁,看到一個大方框寫著
   「**Drag and drop your site output folder here**」
2. 把**整個專案資料夾**(就是含 index.html、admin/、assets/ 的那個資料夾)
   **直接用滑鼠拖到方框裡**放開
3. 等約 30 秒,Netlify 會給你一個網址,例如:
   `https://shiny-otter-12345.netlify.app`
4. 點進去,網站已經上線 ✓

> 📌 想換好記的網址?
> Site settings → Site information → Change site name → 改成例如
> `keelung-ocean-lions` → 網址就變 `https://keelung-ocean-lions.netlify.app`

---

## 第 3 步 · 開啟登入功能(Identity + Git Gateway)

1. 在 Netlify 後台,左側選 **Site settings**
2. 找到 **Identity** → 點「**Enable Identity**」
3. 往下滑到 **Registration preferences**
   → 點 Edit settings → 選「**Invite only**」→ Save
   > 這代表「只能由會長邀請的人才能登入」,外人無法自行註冊
4. 繼續往下滑到 **Services → Git Gateway**
   → 點「**Enable Git Gateway**」
   > 這是讓後台能直接寫回網站內容的橋樑

---

## 第 4 步 · 邀請委員 Email

1. 回到上方,點 **Identity** 主頁籤(不是 Settings,是頁頂的)
2. 點右上「**Invite users**」
3. 一次貼上所有委員 Email(每行一個,或用逗號分隔),按 Send
4. 委員會收到一封 Netlify 寄來的邀請信
   → 委員點信中連結 → **自己設一個密碼** → 完成

---

## 完成 · 接下來

- **網站正式網址**:`https://你取的名字.netlify.app`
- **後台網址**:`https://你取的名字.netlify.app/admin/`
- 之後要修改首頁文字、發最新消息、新增活動,
  都用後台處理,**不必再上傳檔案**
- 委員的使用說明請參考 `ADMIN-USERS-GUIDE.md`,
  可直接複製貼到 LINE 群組

---

> 有問題隨時可以重新拖曳資料夾上去覆蓋,網址不會變、後台帳號不會掉。
