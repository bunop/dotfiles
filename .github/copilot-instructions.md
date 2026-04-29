# Dotfiles – Project Guidelines

Personal configuration files for Paolo Cozzi, managed as symlinks from `$HOME`.

## Structure

Each module is a top-level directory. Files inside are symlinked into `$HOME` with a dot prefix:

```
<module>/<file>         →  ~/.<file>
<module>/<dir>/<file>   →  ~/.<dir>/<file>
```

Examples:
- `bash/bashrc`    → `~/.bashrc`
- `git/gitconfig`  → `~/.gitconfig`
- `R/R/Makevars`   → `~/.R/Makevars`  *(nested path: module dir `R/`, subdir `R/`)*

Current modules: `bash`, `git`, `R`, `tmux`, `vim`, `psql`, `screen`, `sqlite`.

## Installation

```bash
bin/install <module>   # e.g. bin/install bash
```

The script (`bin/install`):
- Creates parent directories as needed
- Backs up existing files as `.filename.bak` before overwriting (skips if `.bak` already exists)
- Skips files already correctly symlinked

## Conventions

- **Adding a file to an existing module**: drop the file in the module directory; `bin/install <module>` will pick it up automatically.
- **Adding a new module**: create a new top-level directory; `bin/install <name>` works immediately.
- **Nested destinations** (e.g. `~/.config/foo`): mirror the subdirectory structure inside the module directory (e.g. `<module>/config/foo`).
- **Backup files** (`*~`) are gitignored — don't commit them.
- **No `.bak` files** should be committed; they are transient artifacts of the install script.

## Git

- Pull strategy: fast-forward only (`ff = only`)
- Merge tool: `vimdiff`
- Useful aliases: `git mytree`, `git ignore`, `git unignore`, `git ignored`, `git exclude`
