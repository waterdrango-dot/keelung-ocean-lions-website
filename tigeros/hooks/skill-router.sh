#!/usr/bin/env sh
# TigerOS 技能路由器 — UserPromptSubmit hook
#
# 把技能觸發從「模型讀 description 自行判斷」變成「規則評分後明示提醒」。
# stdout 會被加進 context（官方文件：UserPromptSubmit 是少數 stdout 進 context 的事件）。
#
# 額外功能：偵測雲端 session（$CLAUDE_CODE_REMOTE），
# 若命中的技能標記為 runtime=local（需本機 Chrome／桌面 LINE／地端 Codex／NAS），
# 先警告跑不動，避免排程每天定時失敗一次。
#
# 規則檔：tigeros/skills/skill-rules.json
# 一律 exit 0——路由器永遠不該擋住使用者的話。

set -u
DIR=$(cd "$(dirname "$0")/.." 2>/dev/null && pwd) || exit 0
RULES="$DIR/skills/skill-rules.json"

[ -f "$RULES" ] || exit 0
command -v python3 >/dev/null 2>&1 || exit 0

# stdin 先收進變數：heredoc 會佔用 stdin，payload 必須改走環境變數
PAYLOAD=$(cat)
[ -n "$PAYLOAD" ] || exit 0

RULES="$RULES" PAYLOAD="$PAYLOAD" python3 <<'PY' 2>/dev/null || true
import sys, json, os, re

try:
    rules = json.load(open(os.environ["RULES"], encoding="utf-8"))
except Exception:
    sys.exit(0)

try:
    payload = json.loads(os.environ.get("PAYLOAD", ""))
except Exception:
    sys.exit(0)

prompt = payload.get("prompt") or payload.get("user_prompt") or ""
if not isinstance(prompt, str) or not prompt.strip():
    sys.exit(0)

cfg = rules.get("config", {})
sc = rules.get("scoring", {})
kw_pts = sc.get("keyword", 2)
in_pts = sc.get("intent", 4)
min_score = cfg.get("minScore", 3)
max_show = cfg.get("maxShow", 3)

low = prompt.lower()
hits = []

for name, spec in rules.get("skills", {}).items():
    if not isinstance(spec, dict):
        continue
    score, why = 0, []
    for k in spec.get("keywords", []):
        if k.lower() in low:
            score += kw_pts
            why.append(k)
    for pat in spec.get("intents", []):
        try:
            if re.search(pat, prompt):
                score += in_pts
                why.append("意圖")
        except re.error:
            pass
    if score >= min_score:
        hits.append((score, name, spec.get("runtime", "any"), why))

if not hits:
    sys.exit(0)

hits.sort(key=lambda x: -x[0])
hits = hits[:max_show]

is_remote = os.environ.get("CLAUDE_CODE_REMOTE", "").lower() == "true"

out = ["", "【TigerOS 技能路由】偵測到可能適用的技能："]
for score, name, runtime, why in hits:
    seen, uniq = set(), []
    for w in why:
        if w not in seen:
            seen.add(w)
            uniq.append(w)
    out.append("  - %s（命中 %d 分：%s）" % (name, score, "、".join(uniq[:4])))

local_hits = [h for h in hits if h[2] == "local"]
if is_remote and local_hits:
    out.append("")
    out.append("⚠️  目前是雲端 session，但以下技能需要本機環境"
               "（Chrome／桌面版 LINE／地端 Codex／NAS），在這裡跑不動：")
    for h in local_hits:
        out.append("  - %s" % h[1])
    out.append("  → 改在本機 Claude Code 執行，或先確認資料是否已可從 ERP API 取得。")
    out.append("  → 說明見 tigeros/routines/catalog.md")

out.append("")
print("\n".join(out))
PY

exit 0
