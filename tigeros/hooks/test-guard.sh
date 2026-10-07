#!/usr/bin/env sh
# guard-bash.sh 的回歸測試
# 用法：sh tigeros/hooks/test-guard.sh
# 離開碼 0 = 全過

set -u
GUARD="$(cd "$(dirname "$0")" && pwd)/guard-bash.sh"
PASS=0; FAIL=0

# $1=說明 $2=要測的指令 $3=期望離開碼(2=擋 0=放行)
t() {
  payload=$(CMD="$2" python3 -c 'import json,os;print(json.dumps({"tool_name":"Bash","tool_input":{"command":os.environ["CMD"]}}))')
  printf '%s' "$payload" | sh "$GUARD" >/dev/null 2>&1
  rc=$?
  if [ "$rc" = "$3" ]; then
    PASS=$((PASS+1)); printf '  ✓ %s\n' "$1"
  else
    FAIL=$((FAIL+1)); printf '  ✗ %s — 期望 rc=%s 實得 rc=%s\n' "$1" "$3" "$rc"
  fi
}

D=docker; C=compose

echo "應攔截（rc=2）:"
t "compose down"        "$D $C down"                                   2
t "compose stop api"    "cd /volume2/docker/chengbao-ops && $D $C stop api" 2
t "compose restart"     "$D $C restart api"                            2
t "up -d --build"       "$D $C up -d --build"                          2
t "compose build"       "$D $C build api"                              2
t "hyphen 版 down"      "$D-$C down"                                   2
t "prisma db push"      "npx prisma db push"                           2
t "prisma migrate deploy" "pnpm prisma migrate deploy"                 2
t "prisma migrate reset"  "pnpm prisma migrate reset --force"          2
t "--no-verify"         "git commit -m x --no-verify"                  2
t "force push main"     "git push --force origin main"                 2
t "force push master"   "git push -f origin master"                    2

echo "應放行（rc=0）:"
t "deploy-api.sh"       "bash /volume2/docker/chengbao-ops/deploy-api.sh" 0
t "compose ps"          "$D $C ps"                                     0
t "compose logs"        "$D $C logs -f api"                            0
t "git status"          "git status"                                   0
t "push 一般分支"        "git push -u origin claude/foo"                0
t "force push 非 main"   "git push --force-with-lease origin claude/foo" 0
t "prisma generate"     "pnpm prisma generate"                         0
t "prisma validate"     "pnpm prisma validate"                         0
t "pnpm test"           "pnpm test"                                    0

echo "heredoc 內容應被剝除（寫檔 != 執行）:"
t "heredoc 含禁令字串" "cat > note.md <<'EOF'
部署時不要跑 $D $C down
EOF" 0

echo ""
echo "通過 $PASS 項｜失敗 $FAIL 項"
[ "$FAIL" -eq 0 ]
