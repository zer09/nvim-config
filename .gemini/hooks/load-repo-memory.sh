#!/usr/bin/env bash
# Gemini SessionStart hook — inject repo memory index into context
MEMORY_INDEX="/home/gc/.config/nvim/.memory/MEMORY.md"

if [ -f "$MEMORY_INDEX" ]; then
  content=$(cat "$MEMORY_INDEX")
  jq -n --arg content "$content" '{
    hookSpecificOutput: {
      additionalContext: ("REPO MEMORY INDEX (.memory/MEMORY.md):\n" + $content + "\n\nRead individual files from /home/gc/.config/nvim/.memory/ when their content is relevant.")
    }
  }'
else
  echo '{}'
fi
