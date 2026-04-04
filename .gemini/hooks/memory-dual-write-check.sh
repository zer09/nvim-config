#!/usr/bin/env bash
# Gemini AfterTool hook — remind to dual-write memory files
input=$(cat)
file_path=$(echo "$input" | jq -r '.tool_input.file_path // ""')

if echo "$file_path" | grep -qE '(/\.memory/|/memory/)[^/]+\.md$'; then
  jq -n '{
    hookSpecificOutput: {
      additionalContext: "\n\nMEMORY DUAL-WRITE REMINDER: You just wrote a memory file. Verify you also wrote to the other location (e.g., Claude auto-memory at ~/.claude/projects/-home-gc--config-nvim/memory/ or the repo .memory/) and updated both MEMORY.md indexes."
    }
  }'
else
  echo '{}'
fi
