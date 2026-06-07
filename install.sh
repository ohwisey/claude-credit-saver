#!/usr/bin/env bash
# Claude Code Credit Saver: one-line installer
# Installs: /handoff + /resume commands, the context meter (status line),
# and the long-chat warning hook. It backs up and safely MERGES your settings,
# so nothing you already have is lost.
set -e

# Set automatically when published. Lets "curl ... | bash" download what it needs.
RAW_BASE="https://raw.githubusercontent.com/ohwisey/claude-credit-saver/main"

CLAUDE_DIR="${HOME}/.claude"
CMD_DIR="${CLAUDE_DIR}/commands"
HOOK_DIR="${CLAUDE_DIR}/hooks"
SETTINGS="${CLAUDE_DIR}/settings.json"
SRC="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd || echo "")"

echo "Installing Claude Code Credit Saver..."

if ! command -v jq >/dev/null 2>&1; then
  echo ""
  echo "This installer needs 'jq' to edit your settings safely. Install it, then re-run:"
  echo "  Mac:    brew install jq"
  echo "  Linux:  sudo apt-get install jq"
  exit 1
fi

# Use a local file if we are running from a clone, otherwise download it.
get() { # $1 = path relative to repo root
  if [ -n "$SRC" ] && [ -f "$SRC/$1" ]; then cat "$SRC/$1"; else curl -fsSL "$RAW_BASE/$1"; fi
}

mkdir -p "$CMD_DIR" "$HOOK_DIR"

# 1) Commands
get commands/handoff.md      > "$CMD_DIR/handoff.md"
get commands/resume.md       > "$CMD_DIR/resume.md"
get commands/handoff-hide.md > "$CMD_DIR/handoff-hide.md"
get commands/handoff-show.md > "$CMD_DIR/handoff-show.md"
echo "  - installed /handoff, /resume, /handoff-hide, /handoff-show"

# 2) Scripts
get scripts/statusline.sh         > "$CLAUDE_DIR/credit-saver-statusline.sh"
get scripts/check-context-size.sh > "$HOOK_DIR/credit-saver-check.sh"
chmod +x "$CLAUDE_DIR/credit-saver-statusline.sh" "$HOOK_DIR/credit-saver-check.sh"
echo "  - installed the context meter and warning hook"

# 3) Settings: back up, then merge (never overwrite)
[ -f "$SETTINGS" ] || echo '{}' > "$SETTINGS"
cp "$SETTINGS" "${SETTINGS}.creditsaver-backup"

tmp="$(mktemp)"
jq \
  --arg sl "$CLAUDE_DIR/credit-saver-statusline.sh" \
  --arg hk "$HOOK_DIR/credit-saver-check.sh" '
  .statusLine = {type:"command", command:$sl, refreshInterval:5}
  | .hooks = (.hooks // {})
  # clean up any old Stop-hook wiring from earlier versions
  | (if .hooks.Stop then
       .hooks.Stop = [ (.hooks.Stop[]) | select(((.hooks // []) | map(.command) | index($hk)) | not) ]
       | (if (.hooks.Stop | length) == 0 then del(.hooks.Stop) else . end)
     else . end)
  # the warning is a UserPromptSubmit hook (the event that actually surfaces in the app)
  | .hooks.UserPromptSubmit = (
      [ (.hooks.UserPromptSubmit // [])[]
        | select(((.hooks // []) | map(.command) | index($hk)) | not) ]
      + [ {hooks:[{type:"command", command:$hk, timeout:10}]} ]
    )
' "$SETTINGS" > "$tmp" && mv "$tmp" "$SETTINGS"
echo "  - wired up your settings (backup: ${SETTINGS}.creditsaver-backup)"

echo ""
echo "Done. Start a NEW Claude Code session to see it."
echo "You will get a context meter at the bottom, plus /handoff and /resume."
