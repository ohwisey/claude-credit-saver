# HANDOFF — Claude Credit Saver (Patreon video project)

## RESUME HERE
- **Working on:** a free Claude Code "credit saver" toolkit for Liam's Patreon. It is BUILT and TESTED.
- **Next step:** pick one. (A) test it on this machine by running `./install.sh`, or (B) publish to GitHub and fill the `REPLACE_ME` username so the one-line installer works.
- **Waiting on you:** the GitHub account to publish under (Luke's or a shared one with Liam).

----- details -----

**What it is:** two commands (`/handoff`, `/resume`) + a live context meter + a long-chat warning + a one-line installer. A free funnel piece for Liam's paying Patreon members. Keep it free, do not sell it. Nothing here touches Vitality, it is a fully separate project.

**Done so far:** all files written and tested (scripts pass syntax, meter shows green/yellow/red correctly, warning hook fires at 70% and 85%, installer safely MERGES into settings.json without clobbering existing config). This folder is now its own git repo.

**Key files:**
- `README.md` — the guide + one-line install instructions
- `install.sh` — the installer. Has a `REPLACE_ME` placeholder for the GitHub username (also in the README curl line). Fill both in on publish.
- `commands/handoff.md`, `commands/resume.md` — the two commands
- `scripts/statusline.sh` — the live context meter
- `scripts/check-context-size.sh` — the 70% / 85% warning hook

**Watch out:**
- `install.sh` needs `jq` (it tells the user to `brew install jq` if missing). It backs up settings.json before merging.
- To publish: create the GitHub repo, replace `REPLACE_ME` in `install.sh` and `README.md` with the username, commit, push. Then the one-line `curl ... | bash` works.
- Testing the installer here will modify this machine's `~/.claude/settings.json` (it backs it up first).
