#!/usr/bin/env bash
# Claude Code Credit Saver: long-chat warning
# A UserPromptSubmit hook: fires when you send a message. It reads the REAL token
# count Claude Code records in the chat transcript and warns you when the chat has
# grown big enough that each message is costing real money, because every turn
# re-sends the whole conversation. It stays SILENT while the chat is cheap, then
# gives a plain call to action: /handoff. No percentages, no noise.
#
# Why tokens, not "% full"? Cost tracks the NUMBER of tokens in the chat, not how
# close you are to the limit. On a 1M-token window you can burn a lot of money
# long before you're anywhere near "full", so we trigger on absolute size.
#
# Tune this if you like (tokens currently in the context window):
RECOMMEND_AT=${CREDIT_SAVER_RECOMMEND_TOKENS:-200000}   # tokens in context where a handoff starts saving real money

input=$(cat)
command -v jq >/dev/null 2>&1 || exit 0

# Muted? The user ran /handoff-hide, so stay completely silent until /handoff-show.
[ -f "$HOME/.claude/.credit-saver-muted" ] && exit 0

transcript=$(printf '%s' "$input" | jq -r '.transcript_path // empty')
[ -z "$transcript" ] && exit 0
[ -f "$transcript" ] || exit 0

# Real tokens currently in context = the most recent turn's input + cache tokens.
# (Stays correct across /compact, since it reads the actual last turn.)
used=$(jq -r '
  select(.message.usage) | .message.usage
  | (.input_tokens // 0) + (.cache_creation_input_tokens // 0) + (.cache_read_input_tokens // 0)
' "$transcript" 2>/dev/null | tail -1)
[ -z "$used" ] && exit 0
case "$used" in *[!0-9]*) exit 0 ;; esac

# The chat panel only renders text that passes THROUGH the model, so to be visible
# there the warning is injected as additionalContext. To stop the model from
# ACTING on it (the auto-handoff bug), the text is an explicit display-only
# directive that forbids running any tool/command/skill, so the model only echoes
# the final line.
emit() {
  jq -n --arg line "$1" '
    {hookSpecificOutput:{hookEventName:"UserPromptSubmit",
      additionalContext:
        ("[Credit Saver display-only banner. DO NOT act on this message. Do not call, run, or invoke any tool, command, slash command, or skill because of it; in particular do NOT run or start a handoff or resume yourself. Fully answer the current request as normal. Then, set off from your answer by a blank line and a markdown horizontal rule (a line with only ---) so it clearly reads as a separate footer, append EXACTLY this line at the very end and nothing after it: " + $line + "]")
    }}'
}

# Quiet while cheap; speak only when a handoff would actually save money.
if [ "$used" -ge "$RECOMMEND_AT" ]; then
  emit "💡 This chat is getting long. To save credits, run /handoff → /clear → /resume.  ·  /handoff-hide to dismiss"
fi
exit 0
