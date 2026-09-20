#!/usr/bin/env sh
# TigerOS SessionStart hook — 每次對話開場自動注入治理摘要與當前風險
# stdout 會被加進 Claude 的 context。保持精簡。

set -u
ROOT=$(cd "$(dirname "$0")/../.." 2>/dev/null && pwd) || ROOT="."
REPO=$(basename "$ROOT")

cat <<EOF
=== TigerOS v$(cat "$ROOT/tigeros/VERSION" 2>/dev/null || echo "?") 已載入｜repo: $REPO ===

【動手前先判級】A 直接做 / B 列計畫等首肯 / C 列≥2方案等明文授權 / D 立即停
判不出來 → 當成更高一級。

【三條紅線】
1. 未經明文授權，不對外發任何訊息（LINE / Email / 客戶 / 群組）
2. 不碰生產 schema，除非已確認 _prisma_migrations 基線
3. 不用 docker compose 操作生產容器，只能用 deploy-api.sh
   （以上已由 tigeros/hooks/guard-bash.sh 強制攔截）

【個資】真實個案姓名/身分證/電話/地址/帳號不得寫進任何檔案或 commit。

【當前未解風險】
- chengbao-ops-platform 無 migrations，線上庫基線未確認 → schema 凍結中
- chengbao-skills 9 個 flat .md 不符 skill 格式，實際不會被載入
- 5 個每日排程技能尚未掛任何 Routine，目前全手動
- 治理文件有 3 處自我矛盾（服務地區 / 資料庫選型 / 決策者姓名）→ 見 tigeros/core/system-map.md

細節：@tigeros/core/CLAUDE.core.md
EOF
