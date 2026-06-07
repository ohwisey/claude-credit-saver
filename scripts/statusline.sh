#!/usr/bin/env bash
# Claude Code Credit Saver — context meter
# Shows how full the current chat is (plus cost and plan usage) so you know
# exactly when to /handoff. Claude Code feeds this script JSON on stdin.

input=$(cat)

# We read the JSON with jq. If it is missing, show a gentle hint instead of erroring.
if ! command -v jq >/dev/null 2>&1; then
  printf 'credit-saver: run "brew install jq" to see the context meter'
  exit 0
fi

pct=$(printf '%s' "$input"  | jq -r '.context_window.used_percentage // empty')
cost=$(printf '%s' "$input" | jq -r '.cost.total_cost_usd // empty')
five=$(printf '%s' "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')

RESET=$'\e[0m'; GREEN=$'\e[32m'; YELLOW=$'\e[33m'; RED=$'\e[31m'; DIM=$'\e[2m'

# Context meter (the main event)
if [ -n "$pct" ]; then
  p=${pct%.*}; [ -z "$p" ] && p=0
  if   [ "$p" -ge 70 ]; then out="${RED}! ${p}% full - /handoff to save money${RESET}"
  elif [ "$p" -ge 50 ]; then out="${YELLOW}* ${p}% full${RESET}"
  else                       out="${GREEN}* ${p}% full${RESET}"
  fi
else
  out="${DIM}* context: warming up${RESET}"
fi

# Cost so far this session
if [ -n "$cost" ]; then
  out="${out} ${DIM}|${RESET} \$$(printf '%.2f' "$cost" 2>/dev/null || printf '%s' "$cost")"
fi

# Plan usage (Pro / Max only; absent for API-key users, so we just skip it)
if [ -n "$five" ]; then
  f=${five%.*}
  out="${out} ${DIM}| 5h plan: ${f}%${RESET}"
fi

printf '%s' "$out"
