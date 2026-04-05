#!/usr/bin/env bash
# Gemini SessionStart hook — inject repo memory index into context
MEMORY_INDEX="/home/gc/.config/nvim/.memory/MEMORY.md"
CLAUDE_MD="/home/gc/.config/nvim/CLAUDE.md"

content=""
if [ -f "$CLAUDE_MD" ]; then
  content+="CLAUDE.md:\n$(cat "$CLAUDE_MD")\n\n"
fi

if [ -f "$MEMORY_INDEX" ]; then
  content+="REPO MEMORY INDEX (.memory/MEMORY.md):\n$(cat "$MEMORY_INDEX")\n\nRead individual files from /home/gc/.config/nvim/.memory/ when their content is relevant."
fi

if [ -n "$content" ]; then
  jq -n --arg content "$content" '{
    hookSpecificOutput: {
      additionalContext: $content
    }
  }'
else
  echo '{}'
fi
