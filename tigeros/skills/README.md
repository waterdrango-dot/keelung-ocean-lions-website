# Skill 格式規範

## 為什麼你的 skill 沒被載入

Claude Code 只認 **`<技能名>/SKILL.md`** 且必須有 YAML frontmatter。
放在根目錄的 flat `.md` **不會被當成 skill**，只是普通文件。

2026-09-20 盤點 `chengbao-skills`：**9 個 flat `.md` 全部無效**，只有 2 個目錄格式正確。

## 正確格式

```
skills/
└── cb-finance/
    └── SKILL.md
```

```markdown
---
name: cb-finance
description: 一句話說明何時啟用，務必含觸發關鍵字
---

# 內容
```

`description` 決定 Claude 會不會載入這個 skill——寫得越具體越準。

## 修正指令

```bash
cd ~/.claude/skills
for f in cb-finance cb-hr cb-ops cb-brand cb-compliance cb-strategy ai-dispatcher ask-gemini multi-ai; do
  mkdir -p "$f" && git mv "$f.md" "$f/SKILL.md"
done
```

搬完**必須補上 frontmatter**，否則仍然無效。

## 驗證

```bash
sh tigeros/skills/validate-skills.sh ~/.claude/skills
```

## 範本

`tigeros/skills/_template/SKILL.md`
