# dotfiles

Personal configuration files for Paolo Cozzi, managed as symlinks from `$HOME`.

## Structure

Each module is a top-level directory. Files inside are symlinked into `$HOME` with a dot prefix:

```
<module>/<file>         →  ~/.<file>
<module>/<dir>/<file>   →  ~/.<dir>/<file>
```

| Module   | Destination             |
|----------|-------------------------|
| `bash`   | `~/.bashrc`, `~/.bash_aliases`, … |
| `git`    | `~/.gitconfig`          |
| `vim`    | `~/.vimrc`              |
| `tmux`   | `~/.tmux.conf`          |
| `R`      | `~/.Rprofile`, `~/.R/Makevars` |
| `psql`   | `~/.psqlrc`             |
| `screen` | `~/.screenrc`           |
| `sqlite` | `~/.sqliterc`           |

## Installation

```bash
bin/install <module>
```

Examples:

```bash
bin/install bash
bin/install git
bin/install vim
```

The script will:
1. Skip files that are already correctly symlinked
2. Rename existing files to `.filename.bak` (skips if `.bak` already exists)
3. Create the symlink pointing to the file in this repo

## Adding files

**To an existing module** — drop the file in the module directory and run `bin/install <module>` again.

**New module** — create a new top-level directory and run `bin/install <name>`.

**Nested destination** (e.g. `~/.config/foo`) — mirror the subdirectory structure inside the module directory (e.g. `<module>/config/foo`).

## Windows

This branch tracks Windows-specific configurations. Not all modules apply:

| Module       | Valid on Windows?  | Notes |
|--------------|--------------------|-------|
| `powershell` | Yes                | Windows-specific module |
| `git`        | Yes                | Git for Windows reads `~/.gitconfig` |
| `vim`        | Yes                | If Vim/Neovim is installed |
| `R`          | Yes                | R for Windows reads `~/.Rprofile` and `~/.R/Makevars` |
| `bash`       | Partial            | Only with Git Bash or WSL |
| `psql`       | Partial            | Only if PostgreSQL client is installed |
| `sqlite`     | Partial            | Only if sqlite3 is installed |
| `tmux`       | No                 | Not available on Windows |
| `screen`     | No                 | Not available on Windows |

### Installation on Windows

Use the PowerShell script instead of `bin/install`:

```powershell
.\bin\install.ps1 git
.\bin\install.ps1 powershell
.\bin\install.ps1 vim
```

> **Note:** creating symlinks on Windows requires either **Developer Mode** enabled
> (Settings → Privacy & Security → For Developers) or an elevated terminal.

## License

[MIT](LICENSE)
