---
name: gitmoji-commits
description: "Use whenever drafting or writing a git commit message (git commit -m, amend, or any commit created on the user's behalf) in any project. Commit summaries must lead with a gitmoji as a textual shortcode only, e.g. `:sparkles: add feature` — never the rendered emoji glyph (no 🚚, no ✨) and never both glyph and shortcode together. Trigger this before running `git commit` for the first time in a session, or whenever proposing a commit message, so the format is right from the start rather than fixed after the fact."
---

# Gitmoji commits (textual shortcode only)

Commit message summary lines follow [gitmoji](https://gitmoji.dev/) convention, but written as the **textual shortcode**, not the rendered emoji character.

## Format

```
:shortcode: lowercase, imperative summary of the change
```

- One shortcode, at the very start of the summary line, followed by a space.
- No emoji glyph anywhere in the message — not before the shortcode, not instead of it, not appended after. `:sparkles: add x` is correct; `✨ :sparkles: add x` and `✨ add x` are both wrong.
- Summary stays lowercase after the shortcode and in the imperative mood ("add", "fix", "remove" — not "added", "fixes").
- Pick the shortcode that matches the *nature* of the change, not just any default. Common ones:

| Shortcode | Use for |
| --- | --- |
| `:sparkles:` | new feature |
| `:bug:` | bug fix |
| `:memo:` | documentation only |
| `:fire:` | removing code or files |
| `:recycle:` | refactor (no behavior change) |
| `:truck:` | move/rename files or resources |
| `:tada:` | initial commit / start of a project |
| `:wrench:` | config changes |
| `:white_check_mark:` | adding/fixing tests |
| `:arrow_up:` / `:arrow_down:` | dependency upgrade/downgrade |
| `:lock:` | security fix |
| `:zap:` | performance improvement |

If none of these fit, pick the closest match from the full [gitmoji list](https://gitmoji.dev/) — still as a textual shortcode.

## Why textual, not the glyph

The actual emoji character renders inconsistently across terminals, diff tools, and git log output, and some tooling mangles multi-byte glyphs in commit metadata. The shortcode form is unambiguous plain ASCII and still communicates the same intent to anyone using a gitmoji-aware tool (many render the shortcode as an icon automatically).

## Rewriting existing history

If the user asks to fix commit messages that already have the glyph (or wrong shortcode) and none of the affected commits have been pushed yet, this is a straightforward history rewrite:

- For the tip commit only: `git commit --amend -m "..."`.
- For multiple recent commits not yet pushed: `git filter-branch -f --msg-filter '...'` scoped to the affected range (avoid `git rebase -i`, which requires interactive input this environment doesn't support), or reset and recommit one at a time.
- After rewriting, clean up: delete `refs/original/*` backup refs left by `filter-branch`, then `git reflog expire --expire=now --all && git gc --prune=now` so the old glyph-bearing commits don't linger as dangling objects (some tools/GUIs will otherwise show them as "duplicates").
- If any of the rewritten commits were already pushed, warn the user before rewriting that the eventual push will need `--force-with-lease`, since it changes commit hashes that a remote may already have.
