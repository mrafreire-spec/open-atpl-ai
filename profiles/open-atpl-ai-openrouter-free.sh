#!/usr/bin/env bash
# OPEN ATPL AI profile: OpenRouter free model lane
# Usage:
#   export OPENROUTER_API_KEY=...
#   source /Users/antoniofreire/open-atpl-ai/profiles/open-atpl-ai-openrouter-free.sh
#   openclaude

export CLAUDE_CODE_USE_OPENAI=1
export OPENAI_BASE_URL="${OPENAI_BASE_URL:-https://openrouter.ai/api/v1}"
export OPENAI_API_KEY="${OPENROUTER_API_KEY:-${OPENAI_API_KEY:-}}"
export OPENAI_MODEL="${OPENAI_MODEL:-qwen/qwen3-coder:free}"

if [[ -z "${OPENAI_API_KEY}" ]]; then
  echo "Missing OPENROUTER_API_KEY (or OPENAI_API_KEY) for OpenRouter free profile."
  return 1 2>/dev/null || exit 1
fi

echo "OPEN ATPL AI profile active: OpenRouter ${OPENAI_MODEL}"
