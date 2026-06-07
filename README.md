# Claude Code Credit Saver

A tiny free toolkit that keeps Claude Code **fast and cheap** on long projects.

You get two commands and an automatic meter:

- **`/handoff`** — saves your spot to a note
- **`/resume`** — picks it back up in a fresh, cheap chat
- **a context meter** at the bottom of your screen that warns you *before* a chat gets expensive

If you remember one line: **when the chat gets long, `/handoff`, start a fresh chat, `/resume`. Same work, cheaper.**

---

## Why your chats get expensive

Every time you send a message, Claude re-reads the **whole chat** from the top before it answers.

Picture a book. Every new sentence you add, Claude re-reads the whole book first. Short book, quick and cheap. Long book, slow and pricey, and it gets worse every message.

So the trick is: when a chat gets long, jump to a fresh one. A fresh chat normally forgets everything, which is what these tools fix. (You are not stopping your work. You are dropping the heavy chat and continuing in a light one.)

---

## Install in one line

```bash
curl -fsSL https://raw.githubusercontent.com/REPLACE_ME/claude-credit-saver/main/install.sh | bash
```

That installs everything: the two commands, the meter, and the warning. It backs up your settings first and only adds to them, so nothing you already have is touched. (Needs `jq`. If you do not have it: `brew install jq` on Mac.)

Then **start a new Claude Code session** so it loads.

Prefer to do it by hand? See [Manual install](#manual-install) below.

---

## How it works (the sticky-note idea)

Think of leaving work and writing a sticky note for tomorrow.

- **`/handoff`** writes a short note of where you are.
- **`/resume`** reads it in a fresh chat and keeps going. No copy-paste.

The note has two parts:

- **A short top part** ("RESUME HERE"): what you were doing, the next step, anything it needs to ask you.
- **A longer bottom part**: extra detail, only read if needed.

When you `/resume`, the new chat reads **only the short top part** and gets to work. It does not re-read your whole project. That is what saves the money.

---

## The meter (so you never forget)

After installing you get a small readout at the bottom of Claude Code:

```
* 38% full | $0.21 | 5h plan: 26%
```

- **green** under 50%, **yellow** 50 to 70%, **red** over 70%
- at red it literally says `! 72% full - /handoff to save money`
- it also shows your session cost and, on Pro/Max plans, how much of your 5-hour limit you have used

On top of that, a quiet warning pops in once around 70% and again at 85%, so even if you are heads-down, it taps you on the shoulder before the bill climbs.

---

## The whole flow

```
1. /handoff      writes the note
2. /clear        (or open a new chat) — fresh and light
3. /resume       reads the note, keeps going
```

Three steps. The meter tells you when to start.

---

## Bonus built-ins

These come with Claude Code, no install:

- **`/model sonnet`** for easy work (cheaper), **`/model opus`** for hard work (smarter)
- **`/clear`** between tasks to start fresh — your files are always safe

---

## FAQ

**Will I lose my work or code?**
No. A fresh chat only clears the conversation. Your files are never touched. `/handoff` even saves the note to a file.

**Are `/handoff` and `/resume` real Claude Code features?**
No. `/clear` and `/model` are built in. `/handoff`, `/resume`, and the meter are what this toolkit adds.

**Is the meter accurate?**
Yes, the numbers come straight from Claude Code. One quirk: it is blank for the very first message of a chat (nothing has been counted yet), then it fills in.

**Do I need git?**
No. `/handoff` saves a normal file. If your project uses git, it also commits it. Either way works.

---

## Manual install

1. Copy `commands/handoff.md` and `commands/resume.md` into `~/.claude/commands/`.
2. Copy `scripts/statusline.sh` and `scripts/check-context-size.sh` somewhere under `~/.claude/`, and `chmod +x` them.
3. In `~/.claude/settings.json`, point `statusLine` at the statusline script and add the Stop hook. (The installer does this for you with a backup; only do it by hand if you like.)

---

## What's in this repo

```
claude-credit-saver/
  README.md
  install.sh                  one-line installer (safe, backs up settings)
  commands/
    handoff.md                saves your spot
    resume.md                 picks it back up
  scripts/
    statusline.sh             the context meter
    check-context-size.sh     the long-chat warning
```

Small on purpose.
