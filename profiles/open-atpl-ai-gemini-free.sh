#!/usr/bin/env bash
# OPEN ATPL AI profile: Gemini free tier
# Usage:
#   export GOOGLE_API_KEY=...   # or GEMINI_API_KEY
#   source /Users/antoniofreire/open-atpl-ai/profiles/open-atpl-ai-gemini-free.sh
#   openclaude

export CLAUDE_CODE_USE_GEMINI=1
export GEMINI_API_KEY="${GEMINI_API_KEY:-${GOOGLE_API_KEY:-}}"
export GEMINI_MODEL="${GEMINI_MODEL:-gemini-2.5-flash}"

if [[ -z "${GEMINI_API_KEY}" ]]; then
  echo "Missing GEMINI_API_KEY/GOOGLE_API_KEY for Gemini profile."
  return 1 2>/dev/null || exit 1
fi

echo "OPEN ATPL AI profile active: Gemini ${GEMINI_MODEL}"
