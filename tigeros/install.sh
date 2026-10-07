#!/usr/bin/env sh
# 把 TigerOS 掛載到另一個 repo
# 用法：sh tigeros/install.sh /path/to/target-repo [--force]
#
# 做四件事：
#   1. 複製 tigeros/ 到目標 repo
#   2. 建立／更新 .claude/settings.json（接上 hooks）
#   3. 建立 CLAUDE.md（若不存在），匯入核心憲法
#   4. 驗證 hooks 真的會動

set -eu
SRC=$(cd "$(dirname "$0")" && pwd)
TARGET="${1:-}"
FORCE="${2:-}"

[ -n "$TARGET" ] || { echo "用法：sh tigeros/install.sh /path/to/target-repo [--force]"; exit 1; }
[ -d "$TARGET" ] || { echo "目標目錄不存在：$TARGET"; exit 1; }
[ -d "$TARGET/.git" ] || echo "⚠️  $TARGET 不是 git repo，仍繼續。"

if [ -d "$TARGET/tigeros" ] && [ "$FORCE" != "--force" ]; then
  echo "⚠️  $TARGET/tigeros 已存在。加 --force 覆蓋，或先手動比對差異。"
  exit 1
fi

echo "→ 複製 tigeros/ 到 $TARGET"
mkdir -p "$TARGET/tigeros"
cp -R "$SRC/core" "$SRC/hooks" "$SRC/skills" "$SRC/routines" "$SRC/VERSION" "$TARGET/tigeros/"
cp "$SRC/install.sh" "$SRC/settings.json.example" "$SRC/README.md" "$TARGET/tigeros/" 2>/dev/null || true
chmod +x "$TARGET/tigeros/hooks/"*.sh 2>/dev/null || true
chmod +x "$TARGET/tigeros/skills/"*.sh 2>/dev/null || true

mkdir -p "$TARGET/.claude"
if [ -f "$TARGET/.claude/settings.json" ] && [ "$FORCE" != "--force" ]; then
  echo "⚠️  $TARGET/.claude/settings.json 已存在，未覆蓋。"
  echo "    請手動把 tigeros/settings.json.example 的 hooks 區塊併入。"
else
  echo "→ 寫入 .claude/settings.json"
  cp "$SRC/settings.json.example" "$TARGET/.claude/settings.json"
fi

if [ -f "$TARGET/CLAUDE.md" ]; then
  if grep -q 'tigeros/core/CLAUDE.core.md' "$TARGET/CLAUDE.md"; then
    echo "→ CLAUDE.md 已匯入核心憲法，略過"
  else
    echo "→ 在既有 CLAUDE.md 開頭插入核心憲法匯入"
    printf '@tigeros/core/CLAUDE.core.md\n\n' | cat - "$TARGET/CLAUDE.md" > "$TARGET/CLAUDE.md.tmp"
    mv "$TARGET/CLAUDE.md.tmp" "$TARGET/CLAUDE.md"
  fi
else
  echo "→ 建立 CLAUDE.md"
  {
    echo "# CLAUDE.md"
    echo ""
    echo "@tigeros/core/CLAUDE.core.md"
    echo ""
    echo "## 本 repo 專屬規則"
    echo ""
    echo "（待補：這個 repo 是什麼、有什麼特殊約束）"
  } > "$TARGET/CLAUDE.md"
fi

echo ""
echo "→ 驗證"
sh "$TARGET/tigeros/hooks/startup-briefing.sh" >/dev/null 2>&1 \
  && echo "  ✓ startup-briefing.sh 可執行" \
  || echo "  ✗ startup-briefing.sh 失敗"

# 組出禁令字串再測，避免本腳本自身被守衛誤判
PROBE_CMD="$(printf 'docker compose down')"
PROBE="{\"tool_name\":\"Bash\",\"tool_input\":{\"command\":\"$PROBE_CMD\"}}"
if printf '%s' "$PROBE" | sh "$TARGET/tigeros/hooks/guard-bash.sh" >/dev/null 2>&1; then
  echo "  ✗ guard-bash.sh 沒擋住禁令，請檢查！"
  exit 1
else
  echo "  ✓ guard-bash.sh 正常攔截禁令"
fi

PROBE_OK="{\"tool_name\":\"Bash\",\"tool_input\":{\"command\":\"git status\"}}"
if printf '%s' "$PROBE_OK" | sh "$TARGET/tigeros/hooks/guard-bash.sh" >/dev/null 2>&1; then
  echo "  ✓ guard-bash.sh 正常放行一般指令"
else
  echo "  ✗ guard-bash.sh 誤擋一般指令，請檢查！"
  exit 1
fi

ROUTER_PAYLOAD='{"prompt":"幫我做這個月損益"}'
if printf '%s' "$ROUTER_PAYLOAD" | sh "$TARGET/tigeros/hooks/skill-router.sh" 2>/dev/null | grep -q "chengbao-monthly-pnl"; then
  echo "  ✓ skill-router.sh 正常路由技能"
else
  echo "  ✗ skill-router.sh 沒有路由，請檢查 python3 與 skill-rules.json"
  exit 1
fi

echo ""
echo "完成。下一步："
echo "  cd $TARGET && git add tigeros .claude CLAUDE.md && git commit -m 'chore(tigeros): 掛載 TigerOS harness'"
