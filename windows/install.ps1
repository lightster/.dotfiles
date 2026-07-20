#Requires -Version 5.1
<#
.SYNOPSIS
    Windows equivalent of `make configs` - symlinks dotfiles into the home directory.
.DESCRIPTION
    Links git, Claude Code, and PowerShell configuration into place using real
    symlinks. Requires Windows Developer Mode so symlinks can be created without
    running elevated.
#>

$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot

function Test-DeveloperMode {
    $key = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock'
    $value = (Get-ItemProperty -Path $key -Name AllowDevelopmentWithoutDevLicense -ErrorAction SilentlyContinue).AllowDevelopmentWithoutDevLicense
    return $value -eq 1
}

function New-DotfilesSymlink {
    param(
        [Parameter(Mandatory)] [string] $Link,
        [Parameter(Mandatory)] [string] $Target
    )

    if (-not (Test-Path -LiteralPath $Target)) {
        Write-Warning "skip: target does not exist - $Target"
        return
    }

    $parent = Split-Path -Parent $Link
    if (-not (Test-Path -LiteralPath $parent)) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }

    if (Test-Path -LiteralPath $Link) {
        $existing = Get-Item -LiteralPath $Link -Force
        if ($existing.LinkType) {
            # already a symlink/junction - replace it
            $existing.Delete()
        }
        else {
            $backup = "$Link.bak"
            if (Test-Path -LiteralPath $backup) {
                $backup = "$Link.$(Get-Date -Format 'yyyyMMddHHmmss').bak"
            }
            Write-Host "  backing up existing $Link -> $backup"
            Move-Item -LiteralPath $Link -Destination $backup
        }
    }

    # Use `mklink` rather than `New-Item -ItemType SymbolicLink`: under Windows
    # PowerShell 5.1, New-Item still requires elevation even with Developer Mode
    # enabled, whereas mklink honors the unprivileged-create privilege.
    $flag = if (Test-Path -LiteralPath $Target -PathType Container) { '/D ' } else { '' }
    $result = cmd /c "mklink $flag`"$Link`" `"$Target`""
    if ($LASTEXITCODE -ne 0) {
        throw "mklink failed for ${Link}: $result"
    }
    Write-Host "  linked $Link -> $Target"
}

if (-not (Test-DeveloperMode)) {
    Write-Host ''
    Write-Host 'Developer Mode is not enabled.' -ForegroundColor Red
    Write-Host 'Enable it so symlinks can be created without elevation:'
    Write-Host '  Settings -> System -> For developers -> Developer Mode = On'
    Write-Host 'Then re-run this script.'
    exit 1
}

$home_ = $HOME
$claudeDir = Join-Path $home_ '.claude'

Write-Host "Linking dotfiles from $repoRoot" -ForegroundColor Cyan

# git
New-DotfilesSymlink -Link (Join-Path $home_ '.gitconfig')         -Target (Join-Path $repoRoot 'git\gitconfig')
New-DotfilesSymlink -Link (Join-Path $home_ '.gitconfig-windows') -Target (Join-Path $repoRoot 'git\config.d\windows.gitconfig')

# Claude Code
New-DotfilesSymlink -Link (Join-Path $claudeDir 'settings.json') -Target (Join-Path $repoRoot 'claude\settings.windows.json')
New-DotfilesSymlink -Link (Join-Path $claudeDir 'CLAUDE.md')     -Target (Join-Path $repoRoot 'claude\CLAUDE.md')
New-DotfilesSymlink -Link (Join-Path $claudeDir 'rules')         -Target (Join-Path $repoRoot 'claude\rules')
New-DotfilesSymlink -Link (Join-Path $claudeDir 'skills')        -Target (Join-Path $repoRoot 'claude\skills')
New-DotfilesSymlink -Link (Join-Path $claudeDir 'hooks')         -Target (Join-Path $repoRoot 'claude\hooks')

# PowerShell profile
New-DotfilesSymlink -Link $PROFILE -Target (Join-Path $repoRoot 'windows\profile.ps1')

Write-Host ''
Write-Host 'Done.' -ForegroundColor Green

if (-not (Get-Command jq -ErrorAction SilentlyContinue)) {
    Write-Host ''
    Write-Host 'NOTE: jq is not on PATH. The Claude git-push hook and status line need it:' -ForegroundColor Yellow
    Write-Host '  winget install jqlang.jq'
}

Write-Host ''
Write-Host 'Follow-ups:'
Write-Host '  - git/config sets commit.gpgsign=true; configure GPG for commit signing.'
Write-Host '  - Restart Claude Code and open a new PowerShell session to pick up changes.'
