# PowerShell profile - Windows counterpart to zshrc / shell/*
# Symlinked to $PROFILE by windows/install.ps1.

# --- PATH ---------------------------------------------------------------
# Prepend personal bin directories, but only if they exist.
$extraPaths = @(
    (Join-Path $HOME '.local\bin')
    (Join-Path $HOME '.bin')
    (Join-Path $HOME 'go\bin')
    (Join-Path $HOME '.cargo\bin')
)
foreach ($p in $extraPaths) {
    if ((Test-Path -LiteralPath $p) -and ($env:PATH -split ';' -notcontains $p)) {
        $env:PATH = "$p;$env:PATH"
    }
}

# --- Aliases ------------------------------------------------------------
Set-Alias -Name g -Value git

function dotfiles { Set-Location (Join-Path $HOME '.dotfiles') }
function .. { Set-Location .. }
function ... { Set-Location ../.. }

function clauder { claude --permission-mode default --resume @args }

# --- `to` - jump to a project under ~/code or ~/github ------------------
function to {
    param([string] $Project)

    $code = Join-Path $HOME 'code'
    $github = Join-Path $HOME 'github'

    if ([string]::IsNullOrEmpty($Project)) {
        if (Test-Path -LiteralPath $code) {
            Set-Location $code
        }
        else {
            if (-not (Test-Path -LiteralPath $github)) {
                New-Item -ItemType Directory -Path $github | Out-Null
            }
            Set-Location $github
        }
        return
    }

    foreach ($base in @($code, $github)) {
        if (-not (Test-Path -LiteralPath $base)) { continue }

        $direct = Join-Path $base $Project
        if (Test-Path -LiteralPath $direct -PathType Container) {
            Set-Location $direct
            return
        }

        $match = Get-ChildItem -LiteralPath $base -Directory -ErrorAction SilentlyContinue |
            ForEach-Object { Join-Path $_.FullName $Project } |
            Where-Object { Test-Path -LiteralPath $_ -PathType Container } |
            Select-Object -First 1
        if ($match) {
            Set-Location $match
            return
        }
    }

    Write-Error "to: project '$Project' not found in $code or $github"
}

# --- Prompt -------------------------------------------------------------
# Directory name followed by the current git branch, if any.
function prompt {
    $dir = Split-Path -Leaf (Get-Location)
    $branch = git branch --show-current 2>$null
    if ($branch) {
        Write-Host $dir -NoNewline -ForegroundColor Blue
        Write-Host " ($branch)" -NoNewline -ForegroundColor Yellow
    }
    else {
        Write-Host $dir -NoNewline -ForegroundColor Blue
    }
    return ' > '
}
