#!/usr/bin/env sh
# TigerOS PreToolUse guard — 攔截違反治理紅線的 Bash 指令
#
# 安裝：.claude/settings.json 的 hooks.PreToolUse (matcher: "Bash")
# 行為：exit 2 = 阻擋並把 stderr 回饋給模型；exit 0 = 放行
#
# 逃生門（僅限江董明文授權後使用）：
#   TIGEROS_ALLOW_DOCKER=1   放行 docker compose 破壞性指令
#   TIGEROS_ALLOW_SCHEMA=1   放行 prisma 生產 schema 指令
#
# 已知限制：本守衛做字串比對。heredoc 內容會被剝除以避免「寫檔案」被誤判，
# 但若把禁令字串放在一般引號裡（如 echo "docker compose down"）仍會誤擋，
# 此時用上述逃生門，或改用 Write 工具寫檔。

set -u

PAYLOAD=$(cat)

# 取出 tool_input.command，並剝除 heredoc 內容（寫檔 != 執行）
CMD=""
if command -v python3 >/dev/null 2>&1; then
  CMD=$(printf '%s' "$PAYLOAD" | python3 -c '
import sys, json, re
try:
    d = json.load(sys.stdin)
    c = d.get("tool_input", {}).get("command", "")
    # <<EOF ... EOF / <<"EOF" ... EOF / <<-EOF ... EOF
    c = re.sub(r"<<-?\s*([\x27\x22]?)([A-Za-z_][A-Za-z0-9_]*)\1.*?^\s*\2\s*$",
               " <<STRIPPED ", c, flags=re.S | re.M)
    print(c)
except Exception:
    pass' 2>/dev/null)
elif command -v jq >/dev/null 2>&1; then
  CMD=$(printf '%s' "$PAYLOAD" | jq -r '.tool_input.command // ""' 2>/dev/null)
fi
# 解析不出來就退回整包原文比對，寧可誤擋不可漏擋
[ -z "$CMD" ] && CMD="$PAYLOAD"

block() {
  printf '⛔ TigerOS 治理攔截\n\n%s\n' "$1" >&2
  exit 2
}

D1="docker"; C1="compose"

# --- 紅線 3：生產容器操作（2026-05-04 造成 23 分鐘停機）---
if [ "${TIGEROS_ALLOW_DOCKER:-0}" != "1" ]; then
  case "$CMD" in
    *"$D1"*"$C1"*down*|*"$D1-$C1"*down*|\
    *"$D1"*"$C1"*stop*|*"$D1-$C1"*stop*|\
    *"$D1"*"$C1"*restart*|*"$D1-$C1"*restart*)
      block "禁止直接停止生產容器。
2026-05-04 就是這樣造成 18:14-18:37 共 23 分鐘停機。

唯一允許的部署方式：
  bash /volume2/docker/chengbao-ops/deploy-api.sh [source_file]

該腳本會比對源碼 hash、無變更則零停機、並用 flock 防併發。
若這是誤判（例如只是寫文件），設 TIGEROS_ALLOW_DOCKER=1 或改用 Write 工具。" ;;
  esac
  case "$CMD" in
    *"$D1"*"$C1"*up*--build*|*"$D1-$C1"*up*--build*|\
    *"$D1"*"$C1"*build*|*"$D1-$C1"*build*)
      block "禁止直接 build/up 生產容器。
改用：bash /volume2/docker/chengbao-ops/deploy-api.sh" ;;
  esac
fi

# --- 紅線 2：生產資料庫 schema ---
if [ "${TIGEROS_ALLOW_SCHEMA:-0}" != "1" ]; then
  case "$CMD" in
    *prisma*migrate*reset*)
      block "prisma migrate reset 會清空資料庫。這是 D 級操作，立即停止。" ;;
    *prisma*db*push*|*prisma*migrate*deploy*)
      block "未確認 migration 基線前不得變更生產 schema。

已知風險：chengbao-ops-platform 無 migrations 目錄，線上庫可能是 db push 出來的，
與 chengbao-erp 的 migrations 基線不一定對得上。

請先在 NAS 上執行並確認：
  SELECT migration_name, finished_at FROM _prisma_migrations ORDER BY finished_at;

確認後由江董明文授權，再設 TIGEROS_ALLOW_SCHEMA=1 執行。" ;;
  esac
fi

# --- 禁令：繞過 hooks ---
case "$CMD" in
  *--no-verify*)
    block "禁止用 --no-verify 繞過 git hooks（治理母規則絕對禁令）。" ;;
esac

# --- 禁令：對 main force push ---
case "$CMD" in
  *git*push*)
    case "$CMD" in
      *--force*|*-f\ *|*--force-with-lease*)
        case "$CMD" in
          *main*|*master*)
            block "禁止對 main/master 分支 force push（治理母規則絕對禁令）。" ;;
        esac ;;
    esac ;;
  esac

exit 0
