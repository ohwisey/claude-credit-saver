---
description: Save your spot to a HANDOFF.md note so a fresh, cheap chat can continue your work. Pair with /resume.
---

The current chat is getting long and expensive. Save the work to a note so a fresh, cheap chat can keep going. The user will start a new chat and run /resume.

Write the note to HANDOFF.md in the project root (update it if it already exists). Use this exact two-part shape, because a small top section is what keeps the resume cheap:

### Top section
Start the file with a block titled "RESUME HERE" holding only:
- **Working on:** one line, the task.
- **Next step:** the single exact next action (a file to edit or a command to run).
- **Waiting on you:** any decision blocked on the user, with the options. Write "nothing, keep going" if there is none.

Keep this block to about 5 lines. This is the part the next chat reads first, so it must be enough to act on by itself.

### Details section
Below a divider (`-----`), add supporting detail, only what genuinely helps:
- **Done so far:** what is finished.
- **Key files:** exact paths the next chat will touch, each with a few words.
- **Watch out:** gotchas, setup steps, things that broke before.

Reference file paths and commit hashes instead of pasting large chunks of code. Keep the whole note short so it stays cheap to read.

### Rules
- Do not re-read the whole project to write this. Use what you already know from this session. That keeps making the note cheap too.
- Save the file. Then, ONLY if this project uses git, commit it with a short message like "save handoff note". If it is not a git project, just leave the saved file. Do not error either way.
- When done, reply with two short lines: the note's path, and "Now run /clear, then /resume in this same window to continue cheaply."

$ARGUMENTS
