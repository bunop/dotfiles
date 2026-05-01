#Requires -Version 5.1
<#
.SYNOPSIS
    Install dotfiles module by creating symlinks under $HOME.

.DESCRIPTION
    For each file in <module>/, creates a symlink at ~/.<relative_path>.
    Backs up existing files as .<name>.bak before overwriting.
    Skips files that are already correctly symlinked.

    Requires Developer Mode enabled or an elevated prompt to create symlinks.

.PARAMETER Module
    Name of the module directory to install (e.g. "git", "powershell").

.EXAMPLE
    .\bin\install.ps1 git
    .\bin\install.ps1 powershell
#>
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Module
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$DotfilesDir = (Resolve-Path (Join-Path $PSScriptRoot '..') ).Path
$Module = $Module.TrimEnd('\', '/')

if ([string]::IsNullOrWhiteSpace($Module)) {
    Write-Error 'Module name must not be empty.'
    exit 1
}

$SrcDir = Join-Path $DotfilesDir $Module
if (-not (Test-Path $SrcDir -PathType Container)) {
    $available = (Get-ChildItem $DotfilesDir -Directory | Select-Object -ExpandProperty Name) -join ', '
    Write-Error "Module '$Module' not found ($SrcDir).`nAvailable modules: $available"
    exit 1
}

function Install-DotFile {
    param([string]$Src)

    # Relative path from SrcDir, e.g. "gitconfig" or "R\Makevars"
    $rel = $Src.Substring($SrcDir.Length).TrimStart('\', '/')

    # Add a dot prefix to the first path component:
    #   "gitconfig"   -> ".gitconfig"
    #   "R\Makevars"  -> ".R\Makevars"
    $parts = $rel -split '[/\\]', 2
    $parts[0] = '.' + $parts[0]
    $dotRel = $parts -join [System.IO.Path]::DirectorySeparatorChar

    $Target = Join-Path $HOME $dotRel
    $TargetDir = Split-Path $Target -Parent

    # Ensure parent directory exists
    if (-not (Test-Path $TargetDir -PathType Container)) {
        New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
        Write-Host "created dir: $TargetDir"
    }

    # Already the correct symlink — skip
    if (Test-Path $Target) {
        $item = Get-Item $Target -Force
        if ($item.LinkType -eq 'SymbolicLink') {
            $resolved = (Resolve-Path $item.Target -ErrorAction SilentlyContinue)?.Path
            if ($resolved -eq (Resolve-Path $Src).Path) {
                Write-Host "already linked: $Target"
                return
            }
        }

        # Target exists (regular file or wrong symlink) — back it up
        $Bak = $Target + '.bak'
        if (Test-Path $Bak) {
            Write-Host "SKIP: backup already exists: $Bak"
            return
        }
        Write-Host "backup: $Target -> $Bak"
        Move-Item -LiteralPath $Target -Destination $Bak
    }

    New-Item -ItemType SymbolicLink -Path $Target -Target $Src | Out-Null
    Write-Host "linked: $Target -> $Src"
}

$files = Get-ChildItem -LiteralPath $SrcDir -File -Recurse | Sort-Object FullName
foreach ($file in $files) {
    Install-DotFile -Src $file.FullName
}
