#!/usr/bin/env sh
# skill-router.sh 的回歸測試
# 用法：sh tigeros/hooks/test-router.sh

set -u
ROUTER="$(cd "$(dirname "$0")" && pwd)/skill-router.sh"
PASS=0; FAIL=0

# $1=說明 $2=使用者輸入 $3=期望在輸出中出現的字串（空字串 = 期望無輸出）
t() {
  payload=$(P="$2" python3 -c 'import json,os;print(json.dumps({"hook_event_name":"UserPromptSubmit","prompt":os.environ["P"]}))')
  out=$(printf '%s' "$payload" | sh "$ROUTER" 2>/dev/null)
  if [ -z "$3" ]; then
    if [ -z "$out" ]; then PASS=$((PASS+1)); printf '  ✓ %s（正確無觸發）\n' "$1"
    else FAIL=$((FAIL+1)); printf '  ✗ %s — 不該觸發卻有輸出\n' "$1"; fi
  else
    if printf '%s' "$out" | grep -q "$3"; then PASS=$((PASS+1)); printf '  ✓ %s → %s\n' "$1" "$3"
    else FAIL=$((FAIL+1)); printf '  ✗ %s — 輸出沒有 %s\n' "$1" "$3"; printf '%s\n' "$out" | head -4; fi
  fi
}

echo "應路由到正確技能:"
t "月損益"       "幫我做這個月損益"           "chengbao-monthly-pnl"
t "三方對帳"     "把 LINE 跟銀行對一下"       "cb-payment-reconciliation"
t "今日班表"     "今天誰上班"                 "cb-schedule-reminder-today"
t "明日班表"     "明天排班預告發了嗎"         "cb-schedule-reminder-tomorrow"
t "週班表"       "本週班表彙整一下"           "cb-schedule-reminder-weekly"
t "居家合約"     "幫這個個案做合約"           "chengbao-homecare-contract"
t "薪資撥轉"     "這次薪轉筆數對不上"         "cb-salary-transfer"
t "主管會議"     "準備這個月主管會議"         "bonjump-meeting-builder"
t "早會"         "準備明天早會"               "bonjump-morning-briefing"
t "問卷"         "做一份問卷"                 "survey-builder"
t "經營分析"     "跟去年同期比營收成長多少"   "chengbao-mgmt-analysis"

echo "不該誤觸:"
t "閒聊"         "今天天氣如何"               ""
t "無關技術問題" "幫我看一下這段 CSS"         ""

echo "雲端 session 警告:"
payload=$(python3 -c 'import json;print(json.dumps({"prompt":"幫我做這個月損益"}))')
out=$(printf '%s' "$payload" | CLAUDE_CODE_REMOTE=true sh "$ROUTER" 2>/dev/null)
if printf '%s' "$out" | grep -q "雲端 session"; then
  PASS=$((PASS+1)); printf '  ✓ 雲端 session 有警告本機依賴\n'
else
  FAIL=$((FAIL+1)); printf '  ✗ 雲端 session 未警告\n'; printf '%s\n' "$out"
fi
out=$(printf '%s' "$payload" | env -u CLAUDE_CODE_REMOTE sh "$ROUTER" 2>/dev/null)
if printf '%s' "$out" | grep -q "雲端 session"; then
  FAIL=$((FAIL+1)); printf '  ✗ 本機 session 不該出現雲端警告\n'
else
  PASS=$((PASS+1)); printf '  ✓ 本機 session 正確不警告\n'
fi

echo "健壯性:"
out=$(printf '%s' 'not json' | sh "$ROUTER" 2>/dev/null); rc=$?
[ "$rc" = 0 ] && { PASS=$((PASS+1)); printf '  ✓ 壞輸入不會爆（rc=0）\n'; } || { FAIL=$((FAIL+1)); printf '  ✗ 壞輸入 rc=%s\n' "$rc"; }
out=$(printf '%s' '{"prompt":""}' | sh "$ROUTER" 2>/dev/null); rc=$?
[ "$rc" = 0 ] && { PASS=$((PASS+1)); printf '  ✓ 空輸入不會爆\n'; } || { FAIL=$((FAIL+1)); printf '  ✗ 空輸入 rc=%s\n' "$rc"; }

echo ""
echo "通過 $PASS 項｜失敗 $FAIL 項"
[ "$FAIL" -eq 0 ]
