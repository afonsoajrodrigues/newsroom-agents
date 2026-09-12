#!/usr/bin/env bash
# PreToolUse hook: deny Read on .pdf files so every PDF goes through pdf2md.py.
input="$(cat)"
if printf '%s' "$input" | grep -Eiq '"file_path"[[:space:]]*:[[:space:]]*"[^"]*\.pdf"'; then
  cat <<JSON
{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"Reading PDFs directly is blocked by document-tools. Run: python3 \"\${CLAUDE_PLUGIN_ROOT}/scripts/pdf2md.py\" <file.pdf> and read the resulting docs_cache/*.md instead (or use the pdf-archivist agent)."}}
JSON
fi
exit 0
