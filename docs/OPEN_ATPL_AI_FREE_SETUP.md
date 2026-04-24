# OPEN ATPL AI - Free Runtime Setup

## Goal
Run OPEN ATPL AI with zero API cost by default, using the strongest free model lane available at startup.

## Auto launcher

```bash
cd /Users/antoniofreire/open-atpl-ai
scripts/run-open-atpl-ai-free.sh
```

Shortcut:

```bash
cd /Users/antoniofreire/open-atpl-ai
./open-atpl-ai
```

Priority order used by the launcher:
1. `qwen3:14b` on local Ollama (`localhost:11434`)
2. `deepseek-r1:14b` on local Ollama
3. `qwen3:8b` on Mac Mini Ollama (`192.168.1.181:11434`)
4. `gemini-2.5-flash` (if `GEMINI_API_KEY` or `GOOGLE_API_KEY` exists)
5. `qwen/qwen3-coder:free` via OpenRouter (if `OPENROUTER_API_KEY` exists)

## Manual profiles

- Local Studio:
  - `source /Users/antoniofreire/open-atpl-ai/profiles/open-atpl-ai-local-studio.sh`
- Gemini Free:
  - `source /Users/antoniofreire/open-atpl-ai/profiles/open-atpl-ai-gemini-free.sh`
- OpenRouter Free:
  - `source /Users/antoniofreire/open-atpl-ai/profiles/open-atpl-ai-openrouter-free.sh`

Then start OpenClaude:

```bash
openclaude
```

## Notes
- No secrets are stored in repo files.
- Keep keys in local shell env or local `.env` only.
- If local Ollama is available, the launcher always prefers local free models first.
