#!/usr/bin/env sh
# TigerOS skill 格式驗證器
# 用法：sh tigeros/skills/validate-skills.sh [skills目錄]
# 預設檢查 ~/.claude/skills

set -u
DIR="${1:-$HOME/.claude/skills}"
[ -d "$DIR" ] || { echo "找不到目錄：$DIR"; exit 1; }

echo "檢查：$DIR"
echo ""
OK=0; BAD=0

# 1. 根目錄的 flat .md → 不會被載入
for f in "$DIR"/*.md; do
  [ -e "$f" ] || continue
  case "$(basename "$f")" in README.md|CLAUDE.md) continue ;; esac
  echo "✗ $(basename "$f") — 根目錄的 .md 不會被當成 skill 載入"
  echo "    修正：mkdir -p $DIR/$(basename "$f" .md) && git mv $f $DIR/$(basename "$f" .md)/SKILL.md"
  BAD=$((BAD+1))
done

# 2. 子目錄需有 SKILL.md 且 frontmatter 含 name + description
for d in "$DIR"/*/; do
  [ -d "$d" ] || continue
  n=$(basename "$d")
  case "$n" in _*) continue ;; esac
  s="$d/SKILL.md"
  if [ ! -f "$s" ]; then
    echo "✗ $n/ — 缺 SKILL.md"; BAD=$((BAD+1)); continue
  fi
  head -1 "$s" | grep -q '^---' || { echo "✗ $n/SKILL.md — 第一行不是 YAML frontmatter 的 ---"; BAD=$((BAD+1)); continue; }
  fm=$(sed -n '2,/^---$/p' "$s")
  miss=""
  printf '%s' "$fm" | grep -q '^name:' || miss="$miss name"
  printf '%s' "$fm" | grep -q '^description:' || miss="$miss description"
  if [ -n "$miss" ]; then
    echo "✗ $n/SKILL.md — frontmatter 缺欄位:$miss"; BAD=$((BAD+1))
  else
    echo "✓ $n"; OK=$((OK+1))
  fi
done

echo ""
echo "合格 $OK 個｜不合格 $BAD 個"
[ "$BAD" -eq 0 ]
