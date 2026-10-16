/* ============================================
   Shared site chrome — nav + footer + SEO + a11y
   ============================================ */

const NAV_PRIMARY = [
  { href: "index.html",       label: "首頁",      key: "home" },
  { href: "about.html",       label: "關於我們",  key: "about" },
  { href: "presidents.html",  label: "歷屆會長",  key: "presidents" },
  { href: "service.html",     label: "公益實踐",  key: "service" },
  { href: "media.html",       label: "影音紀錄",  key: "media" },
  { href: "gallery.html",     label: "Gallery",   key: "gallery" }
];

const NAV_PARTICIPATE = [
  { href: "donate.html",   label: "公益捐款",  key: "donate" },
  { href: "register.html", label: "活動報名",  key: "register" },
  { href: "agm.html",      label: "年度大會",  key: "agm" },
  { href: "members.html",  label: "會員專區",  key: "members" },
  { href: "contact.html",  label: "聯絡我們",  key: "contact" }
];

const BRAND_MARK_SVG = `
<svg viewBox="0 0 64 64" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
  <defs>
    <linearGradient id="brandGrad" x1="0" y1="0" x2="1" y2="1">
      <stop offset="0" stop-color="#0B5394"/>
      <stop offset="1" stop-color="#073763"/>
    </linearGradient>
  </defs>
  <circle cx="32" cy="32" r="30" fill="url(#brandGrad)"/>
  <circle cx="32" cy="32" r="30" fill="none" stroke="#B45F06" stroke-width="1.5"/>
  <path d="M8 38 Q16 32 24 38 T40 38 T56 38" fill="none" stroke="#FFF8E1" stroke-width="1.5" stroke-linecap="round" opacity="0.9"/>
  <path d="M8 44 Q16 38 24 44 T40 44 T56 44" fill="none" stroke="#FFF8E1" stroke-width="1.2" stroke-linecap="round" opacity="0.6"/>
  <g transform="translate(32 24)" fill="#FFF8E1">
    <circle cx="0" cy="0" r="6.5"/>
    <path d="M-9 -3 Q-7 -10 -3 -8 Q-1 -12 0 -10 Q1 -12 3 -8 Q7 -10 9 -3 Q10 1 8 3 Q6 0 5 2 Q3 -2 0 -1 Q-3 -2 -5 2 Q-6 0 -8 3 Q-10 1 -9 -3 Z" opacity="0.92"/>
    <circle cx="-2" cy="-1" r="0.9" fill="#073763"/>
    <circle cx="2" cy="-1" r="0.9" fill="#073763"/>
  </g>
  <g transform="translate(32 9)" fill="#d4a015">
    <polygon points="0,-3 0.9,-0.9 3,-0.9 1.2,0.6 1.8,2.7 0,1.5 -1.8,2.7 -1.2,0.6 -3,-0.9 -0.9,-0.9"/>
  </g>
</svg>`;

function renderNav(activeKey) {
  const primaryLinks = NAV_PRIMARY.map(item => {
    const cls = item.key === activeKey ? "nav__link nav__link--active" : "nav__link";
    return `<a href="${item.href}" class="${cls}" aria-current="${item.key === activeKey ? 'page' : 'false'}">${item.label}</a>`;
  }).join("");

  const partLinks = NAV_PARTICIPATE.map(item => {
    const cls = item.key === activeKey ? "nav-drop__link nav-drop__link--active" : "nav-drop__link";
    return `<a href="${item.href}" class="${cls}">${item.label}</a>`;
  }).join("");

  const isPartActive = NAV_PARTICIPATE.some(i => i.key === activeKey);

  return `
  <a class="skip-link" href="#main">跳至主要內容</a>
  <nav class="nav" aria-label="主要導覽">
    <div class="nav__inner">
      <a href="index.html" class="nav__brand" aria-label="基隆海洋獅子會 首頁">
        <span class="nav__brand-mark">${BRAND_MARK_SVG}</span>
        <span>
          基隆海洋獅子會
          <small>Keelung Ocean Lions Club · Est. 1991</small>
        </span>
      </a>
      <button class="nav__toggle" aria-label="開啟選單" aria-expanded="false" aria-controls="nav-menu">
        <span></span><span></span><span></span>
      </button>
      <div class="nav__menu" id="nav-menu">
        ${primaryLinks}
        <div class="nav-drop ${isPartActive ? 'is-active' : ''}">
          <button class="nav__link nav-drop__trigger" aria-haspopup="true" aria-expanded="false">參與服務 <svg width="10" height="6" viewBox="0 0 10 6" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M1 1l4 4 4-4"/></svg></button>
          <div class="nav-drop__panel" role="menu">
            ${partLinks}
          </div>
        </div>
        <a href="join.html" class="nav__cta ${activeKey === 'join' ? 'is-active' : ''}">加入我們</a>
      </div>
    </div>
  </nav>`;
}

function renderFooter() {
  return `
  <footer class="footer" role="contentinfo">
    <div class="container">
      <div class="footer__grid">
        <div class="footer__brand">
          <h4>基隆海洋獅子會</h4>
          <p style="font-family: var(--font-en); font-size:11px; letter-spacing:0.2em; text-transform:uppercase; color: var(--lion-gold-soft); margin: 4px 0 16px;">Keelung Ocean Lions Club · 國際獅子會 300A5 區</p>
          <p>自 1991 年創會以來，基隆海洋獅子會以「服務先於己」之精神，<br>持續為社會貢獻善行義舉。</p>
          <p style="font-size:12px; color: var(--lion-gold-soft); margin: 12px 0 0; letter-spacing: 0.02em; line-height: 1.7;">隸屬國際獅子會 300A5 區・第一專區<br>與 14 個姊妹分會共同服務基隆</p>
          <div class="footer__socials">
            <a href="javascript:void(0)" aria-label="Facebook" onclick="alert('本會官方 Facebook 帳號建置中，敬請期待。')"><svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true"><path d="M22 12c0-5.5-4.5-10-10-10S2 6.5 2 12c0 5 3.7 9.1 8.4 9.9V14.9H7.9V12h2.5V9.8c0-2.5 1.5-3.9 3.8-3.9 1.1 0 2.2.2 2.2.2v2.5h-1.3c-1.2 0-1.6.8-1.6 1.6V12h2.8l-.4 2.9h-2.3v7C18.3 21.1 22 17 22 12z"/></svg></a>
            <a href="javascript:void(0)" aria-label="LINE" onclick="alert('本會官方 LINE 帳號建置中，敬請期待。')"><svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true"><path d="M19.4 4.6C17.6 3 15 2 12 2 6.5 2 2 5.7 2 10.2c0 4 3.6 7.4 8.5 8 .3.1.7.2.8.5.1.3 0 .8 0 1.1 0 0-.1.7-.1.8-.1.3-.3 1.1 1 .6 1.3-.5 7-4.1 9.5-7.1C23.2 12.4 24 10.3 24 8c0-1.3-.4-2.5-1.2-3.4-.8-1-2.1-1.7-3.4-2zm-9.7 9.6H7c-.2 0-.3-.1-.3-.3V8.5c0-.2.1-.3.3-.3s.3.1.3.3v5.1H10c.2 0 .3.1.3.3s-.1.3-.3.3zm1.7-.3c0 .2-.1.3-.3.3s-.3-.1-.3-.3V8.5c0-.2.1-.3.3-.3s.3.1.3.3v5.4zm5.6 0c0 .1-.1.2-.2.3h-.3l-2.9-3.9V14c0 .2-.1.3-.3.3s-.3-.1-.3-.3V8.6c0-.1.1-.2.2-.3h.3l2.9 3.9V8.5c0-.2.1-.3.3-.3s.3.1.3.3v5.4zm4.5-2.6c.2 0 .3.1.3.3s-.1.3-.3.3h-2.1V13h2.1c.2 0 .3.1.3.3s-.1.3-.3.3h-2.4c-.2 0-.3-.1-.3-.3V8.5c0-.2.1-.3.3-.3h2.4c.2 0 .3.1.3.3s-.1.3-.3.3h-2.1v1.1h2.1z"/></svg></a>
            <a href="javascript:void(0)" aria-label="Instagram" onclick="alert('本會官方 Instagram 帳號建置中，敬請期待。')"><svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true"><rect x="3" y="3" width="18" height="18" rx="5"/><circle cx="12" cy="12" r="4"/><circle cx="17.5" cy="6.5" r="1" fill="currentColor"/></svg></a>
            <a href="javascript:void(0)" aria-label="YouTube" onclick="alert('本會官方 YouTube 帳號建置中，敬請期待。')"><svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true"><path d="M23 7.6s-.2-1.6-.9-2.3c-.9-.9-1.8-.9-2.3-1C16.5 4 12 4 12 4s-4.5 0-7.8.3c-.4.1-1.4.1-2.3 1C1.2 6 1 7.6 1 7.6S.8 9.5.8 11.4v1.7c0 1.9.2 3.7.2 3.7s.2 1.6.9 2.3c.9.9 2.1.9 2.6 1 1.9.2 8 .3 8 .3s4.5 0 7.8-.3c.5-.1 1.4-.1 2.3-1 .7-.7.9-2.3.9-2.3s.2-1.9.2-3.7v-1.7c0-1.9-.2-3.8-.2-3.8zM9.7 15.4V8.9l5.8 3.3-5.8 3.2z"/></svg></a>
          </div>
        </div>
        <div class="footer__col">
          <h5>關於</h5>
          <ul>
            <li><a href="about.html">關於我們</a></li>
            <li><a href="presidents.html">歷屆會長</a></li>
            <li><a href="service.html">公益實踐</a></li>
            <li><a href="media.html">影音紀錄</a></li>
          </ul>
        </div>
        <div class="footer__col">
          <h5>參與</h5>
          <ul>
            <li><a href="donate.html">公益捐款</a></li>
            <li><a href="register.html">活動報名</a></li>
            <li><a href="agm.html">年度大會</a></li>
            <li><a href="join.html">加入我們</a></li>
            <li><a href="members.html">會員專區</a></li>
          </ul>
        </div>
        <div class="footer__col">
          <h5>聯絡資訊</h5>
          <ul>
            <li>202 基隆市中正區<br>義一路 87 號 6 樓之 7</li>
            <li>電話 0928-861093 (秘書 江志偉)</li>
            <li>keelung.ocean.lions@gmail.com</li>
            <li>LINE OA: 建置中</li>
          </ul>
        </div>
      </div>
      <div class="footer__bottom">
        <div class="footer__lions">
          <span class="footer__lions-mark">
            <svg viewBox="0 0 32 32" xmlns="http://www.w3.org/2000/svg" aria-hidden="true"><circle cx="16" cy="16" r="15" fill="#0B5394"/><text x="16" y="14" text-anchor="middle" font-family="serif" font-weight="700" font-size="9" fill="#fff" letter-spacing="0.1em">LIONS</text><text x="16" y="22" text-anchor="middle" font-family="serif" font-size="6" fill="#d4a015" letter-spacing="0.05em">CLUBS</text></svg>
          </span>
          Member of Lions Clubs International · District 300A5
        </div>
        <div>© 2026 Keelung Ocean Lions Club · 基隆海洋獅子會 · All rights reserved.</div>
      </div>
    </div>
  </footer>`;
}

/* ===== Auto-inject SEO meta + structured data ===== */
function injectSEO() {
  const head = document.head;
  const titleEl = document.querySelector("title");
  const baseTitle = titleEl?.textContent || "基隆海洋獅子會 Keelung Ocean Lions Club";
  const desc = document.querySelector('meta[name="description"]')?.content
    || "基隆海洋獅子會 Keelung Ocean Lions Club — 自 1991 年創會，國際獅子會 300A5 區之一員，秉持「服務先於己」精神推動公益服務。";

  const tags = [
    { name: "viewport", content: "width=device-width, initial-scale=1" },
    { name: "theme-color", content: "#0B5394" },
    { property: "og:title", content: baseTitle },
    { property: "og:description", content: desc },
    { property: "og:type", content: "website" },
    { property: "og:locale", content: "zh_TW" },
    { property: "og:site_name", content: "基隆海洋獅子會 Keelung Ocean Lions Club" },
    { name: "twitter:card", content: "summary_large_image" }
  ];

  tags.forEach(({ name, property, content }) => {
    const sel = name ? `meta[name="${name}"]` : `meta[property="${property}"]`;
    if (document.querySelector(sel)) return;
    const m = document.createElement("meta");
    if (name) m.name = name; else m.setAttribute("property", property);
    m.content = content;
    head.appendChild(m);
  });

  if (!document.querySelector('script[type="application/ld+json"]')) {
    const ld = document.createElement("script");
    ld.type = "application/ld+json";
    ld.textContent = JSON.stringify({
      "@context": "https://schema.org",
      "@type": "NGO",
      "name": "基隆海洋獅子會 Keelung Ocean Lions Club",
      "alternateName": "Keelung Ocean Lions Club",
      "foundingDate": "1991",
      "memberOf": { "@type": "Organization", "name": "Lions Clubs International District 300A5" },
      "address": {
        "@type": "PostalAddress",
        "streetAddress": "義一路 87 號 6 樓之 7",
        "addressLocality": "基隆市中正區",
        "postalCode": "202",
        "addressCountry": "TW"
      },
      "telephone": "+886-928-861093",
      "email": "keelung.ocean.lions@gmail.com"
    });
    head.appendChild(ld);
  }
}

function bindMobileNav() {
  const toggle = document.querySelector(".nav__toggle");
  const menu = document.getElementById("nav-menu");
  if (!toggle || !menu) return;
  toggle.addEventListener("click", () => {
    const open = menu.classList.toggle("is-mobile-open");
    toggle.setAttribute("aria-expanded", String(open));
    toggle.classList.toggle("is-x", open);
  });
  document.querySelectorAll(".nav-drop__trigger").forEach(btn => {
    btn.addEventListener("click", (e) => {
      e.preventDefault();
      const drop = btn.closest(".nav-drop");
      const open = drop.classList.toggle("is-open");
      btn.setAttribute("aria-expanded", String(open));
    });
  });
  document.addEventListener("click", (e) => {
    if (!e.target.closest(".nav-drop")) {
      document.querySelectorAll(".nav-drop.is-open").forEach(d => d.classList.remove("is-open"));
    }
  });
}

function mountChrome(activeKey) {
  const navMount = document.getElementById("site-nav");
  const footMount = document.getElementById("site-footer");
  if (navMount) navMount.outerHTML = renderNav(activeKey);
  if (footMount) footMount.outerHTML = renderFooter();
  bindMobileNav();
}

document.addEventListener("DOMContentLoaded", () => {
  injectSEO();
  const active = document.body.dataset.page || "";
  mountChrome(active);
});
