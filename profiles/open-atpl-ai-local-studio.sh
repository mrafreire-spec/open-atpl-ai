#!/usr/bin/env bash
# OPEN ATPL AI profile: Studio local Ollama (best default free local model)
# Usage:
#   source /Users/antoniofreire/open-atpl-ai/profiles/open-atpl-ai-local-studio.sh
#   openclaude

export CLAUDE_CODE_USE_OPENAI=1
export OPENAI_BASE_URL=http://localhost:11434/v1
export OPENAI_API_KEY=ollama
export OPENAI_MODEL=qwen3:14b

echo "OPEN ATPL AI profile active: local Ollama qwen3:14b"
