#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

check_only=0
if [[ "${1:-}" == "--check" ]]; then
  check_only=1
  shift
fi

has_local_ollama_model() {
  local model="$1"
  if command -v ollama >/dev/null 2>&1; then
    ollama list 2>/dev/null | awk 'NR>1 {print $1}' | grep -qx "$model"
    return $?
  fi
  curl -fsS --max-time 2 "http://localhost:11434/api/tags" 2>/dev/null | grep -q "\"name\"[[:space:]]*:[[:space:]]*\"${model}\""
}

has_remote_ollama_model() {
  local host="$1"
  local model="$2"
  curl -fsS --max-time 2 "${host}/api/tags" 2>/dev/null | grep -q "\"name\"[[:space:]]*:[[:space:]]*\"${model}\""
}

use_openai_compatible() {
  local base_url="$1"
  local model="$2"
  export CLAUDE_CODE_USE_OPENAI=1
  export OPENAI_BASE_URL="$base_url"
  export OPENAI_API_KEY="${OPENAI_API_KEY:-ollama}"
  export OPENAI_MODEL="$model"
}

use_gemini_free() {
  local gemini_key="${GEMINI_API_KEY:-${GOOGLE_API_KEY:-}}"
  if [[ -z "$gemini_key" ]]; then
    return 1
  fi
  export CLAUDE_CODE_USE_GEMINI=1
  export GEMINI_API_KEY="$gemini_key"
  export GEMINI_MODEL="${GEMINI_MODEL:-gemini-2.5-flash}"
  return 0
}

use_openrouter_free() {
  local key="${OPENROUTER_API_KEY:-${OPENAI_API_KEY:-}}"
  if [[ -z "$key" ]]; then
    return 1
  fi
  export CLAUDE_CODE_USE_OPENAI=1
  export OPENAI_BASE_URL="${OPENAI_BASE_URL:-https://openrouter.ai/api/v1}"
  export OPENAI_API_KEY="$key"
  export OPENAI_MODEL="${OPENAI_MODEL:-qwen/qwen3-coder:free}"
  return 0
}

launch_openclaude() {
  if command -v openclaude >/dev/null 2>&1; then
    exec openclaude "$@"
  fi

  if command -v bun >/dev/null 2>&1; then
    if [[ ! -d "$ROOT/node_modules" ]]; then
      echo "[INFO] Installing dependencies with bun..."
      bun install
    fi
    exec bun run dev -- "$@"
  fi

  echo "[ERROR] Missing OpenClaude launcher. Install one:"
  echo "  npm install -g @gitlawb/openclaude"
  echo "  or install bun and run this script again."
  exit 1
}

chosen="none"

if has_local_ollama_model "qwen3:14b"; then
  use_openai_compatible "http://localhost:11434/v1" "qwen3:14b"
  chosen="local qwen3:14b (Studio)"
elif has_local_ollama_model "deepseek-r1:14b"; then
  use_openai_compatible "http://localhost:11434/v1" "deepseek-r1:14b"
  chosen="local deepseek-r1:14b (Studio)"
elif has_remote_ollama_model "http://192.168.1.181:11434" "qwen3:8b"; then
  use_openai_compatible "http://192.168.1.181:11434/v1" "qwen3:8b"
  chosen="remote mini qwen3:8b"
elif use_gemini_free; then
  chosen="Gemini ${GEMINI_MODEL} (free tier)"
elif use_openrouter_free; then
  chosen="OpenRouter ${OPENAI_MODEL} (free)"
else
  echo "[ERROR] No free model lane available."
  echo "Expected at least one of:"
  echo "  - Ollama model qwen3:14b or deepseek-r1:14b on localhost"
  echo "  - Ollama qwen3:8b on 192.168.1.181"
  echo "  - GEMINI_API_KEY/GOOGLE_API_KEY"
  echo "  - OPENROUTER_API_KEY"
  exit 1
fi

echo "[INFO] OPEN ATPL AI free lane: ${chosen}"
if [[ "$check_only" -eq 1 ]]; then
  exit 0
fi
launch_openclaude "$@"
