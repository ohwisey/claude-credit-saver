#!/usr/bin/env bash
# Claude Code Credit Saver — long-chat warning
# A Stop hook: fires after each reply. When the chat gets big, it nudges you to
# /handoff so you do not keep paying to re-read a huge conversation.
# It warns once at 70% and once more at 85% per chat, so it never spams you.

input=$(cat)
command -v jq >/dev/null 2>&1 || exit 0

pct=$(printf '%s' "$input" | jq -r '.context_window.used_percentage // empty')
sid=$(printf '%s' "$input" | jq -r '.session_id // "session"')
[ -z "$pct" ] && exit 0
p=${pct%.*}; [ -z "$p" ] && exit 0

warn() {
  jq -n --arg msg "$1" \
    '{hookSpecificOutput:{hookEventName:"Stop", additionalContext:$msg}}'
}

dir="${TMPDIR:-/tmp}/claude-credit-saver"
mkdir -p "$dir" 2>/dev/null

if [ "$p" -ge 85 ] && [ ! -f "$dir/${sid}-85" ]; then
  touch "$dir/${sid}-85"
  warn "This chat is ${p}% full and getting expensive. In one short friendly line, tell the user to run /handoff, then /clear, then /resume in a fresh chat to keep going cheaply."
  exit 0
fi

if [ "$p" -ge 70 ] && [ ! -f "$dir/${sid}-70" ]; then
  touch "$dir/${sid}-70"
  warn "This chat is ${p}% full. In one short friendly line, remind the user they can run /handoff to save their spot and continue in a cheaper fresh chat."
  exit 0
fi

exit 0
