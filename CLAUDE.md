# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

Paolo Cozzi's personal dotfiles. There is no build, lint, or test suite; the only executable is `bin/install`.

## Layout and install mechanism

Each top-level directory is a **module** (`bash`, `git`, `R`, `tmux`, `vim`, `psql`, `screen`, `sqlite`, `claude`). `bin/install <module>` symlinks every file in the module into `$HOME`, **prefixing the first path component with a dot**:

- `bash/bashrc` → `~/.bashrc`
- `git/gitconfig` → `~/.gitconfig`
- `R/R/Makevars` → `~/.R/Makevars` (nested: module dir `R/`, then subdir `R/`)
- `claude/claude/skills/<name>/SKILL.md` → `~/.claude/skills/<name>/SKILL.md`

So files in the repo have **no leading dot**, and nested destinations are expressed by mirroring the directory structure *inside* the module directory (hence the doubled `claude/claude/`, `R/R/`).

`bin/install` behaviour: creates parent dirs, skips files already correctly linked, moves an existing target to `<target>.bak` first (and aborts that file if the `.bak` already exists). Never commit `.bak` files or `*~` backups (the latter are gitignored).

Adding a file to an existing module or creating a new module needs no script changes: drop the file/dir in place and run `bin/install <module>`.

The `claude` module tracks only `skills/` and `commands/` — not `settings.json` or `CLAUDE.md` from `~/.claude`.

## Conventions

- Commit messages use gitmoji as a textual shortcode (e.g. `:wrench: ...`, `:sparkles: ...`), never the emoji glyph — see `claude/claude/skills/gitmoji-commits/SKILL.md`.
- Git config uses `ff = only` for pulls and `vimdiff` as merge tool; custom aliases include `git mytree`, `ignore`, `unignore`, `ignored`, `exclude`.
- Bash config is split across `bashrc`, `bash_aliases`, `docker_aliases`, `poetry_completion`, `profile`, `bash_logout`; keep new aliases/completions in the matching file rather than growing `bashrc`.
- `.github/copilot-instructions.md` and `README.md` hold overlapping descriptions of the install scheme; update them together when the module list or install behaviour changes.
