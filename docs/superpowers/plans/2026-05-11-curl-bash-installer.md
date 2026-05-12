# curl|bash Installer Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the multi-step dotfiles install (clone → setup.sh → install-pack.sh → stow) with a single `curl … | bash -s <profile>` command driven by per-machine Brewfiles.

**Architecture:** Two-stage. `bootstrap.sh` (curl target at repo root) does pre-clone work: oh-my-zsh, Homebrew, repo clone. Then it `exec`s `scripts/install.sh <profile>`, which runs `brew bundle` against `scripts/profiles/Brewfile.<profile>` plus universal helper scripts (oh-my-zsh plugins, kitty setup, macOS defaults, stow prompt, post-stow node + lazyvim, personalize). Profiles are declarative Brewfiles, idempotent via `brew bundle install` and "remove not-in-profile" semantics via prompted `brew bundle cleanup --force`.

**Tech Stack:** Bash, Homebrew Bundle (Brewfiles), GNU stow, oh-my-zsh, git.

**Validation approach (no classic TDD):** This is shell/config code with no unit test framework. Each shell script is validated with `bash -n` (syntax check). Brewfiles are validated with `brew bundle list --file=…` (parses without installing). End-to-end behavior is verified manually on the user's machine after the plan completes.

**Reference spec:** `docs/superpowers/specs/2026-05-11-curl-bash-installer-design.md`

---

### Task 1: Create `scripts/profiles/Brewfile.light`

**Files:**
- Create: `scripts/profiles/Brewfile.light`

- [ ] **Step 1: Create the directory and file**

```bash
mkdir -p scripts/profiles
```

Then write `scripts/profiles/Brewfile.light` with this content:

```ruby
# Brewfile.light — minimum install for MacBook Neo (low-spec machine).
# Includes core shell ergonomics, terminal, editor, and the tools the
# user wants present even on the smallest machine.

# CLI tools
brew "stow"
brew "fzf"
brew "eza"
brew "bat"
brew "ripgrep"
brew "neovim"
brew "lazygit"
brew "gnu-sed"
brew "nvm"
brew "bun"
brew "jq"
brew "xh"
brew "git-delta"
brew "mosh"

# Disabled — documented for awareness, not installed:
# brew "jless"
# brew "jqp"

# Casks
cask "kitty"
cask "font-symbols-only-nerd-font"
cask "1password"
cask "1password-cli"
cask "google-chrome"
cask "slack"
cask "zoom"
cask "orbstack"
cask "claude-code"
cask "onlyoffice"
```

- [ ] **Step 2: Validate Brewfile parses**

Run:

```bash
brew bundle list --file=scripts/profiles/Brewfile.light
```

Expected: prints each package name, one per line. No syntax error. If a package name is unknown, brew will list it anyway — name validity is only checked at install time.

- [ ] **Step 3: Commit**

```bash
git add scripts/profiles/Brewfile.light
git commit -m "feat: add Brewfile.light profile for minimum install"
```

---

### Task 2: Create `scripts/profiles/Brewfile.corporate`

**Files:**
- Create: `scripts/profiles/Brewfile.corporate`

- [ ] **Step 1: Write the file**

```ruby
# Brewfile.corporate — Air-class machines (16/32GB), work-style use.
# Excludes security/networking tools (nmap, httrack) that corp policies
# often flag. Excludes personal-only apps (discord, wacom-tablet, etc.).
# Switches orbstack -> docker for compatibility on work environments.

# CLI tools — light set
brew "stow"
brew "fzf"
brew "eza"
brew "bat"
brew "ripgrep"
brew "neovim"
brew "lazygit"
brew "gnu-sed"
brew "nvm"
brew "bun"
brew "jq"
brew "xh"
brew "git-delta"
brew "mosh"

# CLI tools — corporate additions
brew "starship"
brew "dasel"
brew "ast-grep"
brew "prettyping"
brew "expect"
brew "awscli"
brew "groff"
brew "gh"
brew "glab"
brew "libpq"
brew "sqlite"
brew "ffmpeg"

# Disabled — documented for awareness, not installed:
# brew "jless"
# brew "jqp"
# brew "kubectl"
# brew "kubectx"
# brew "kubens"
# brew "derailed/k9s/k9s"

# Casks — light set (orbstack replaced by docker below)
cask "kitty"
cask "font-symbols-only-nerd-font"
cask "1password"
cask "1password-cli"
cask "google-chrome"
cask "slack"
cask "zoom"
cask "claude-code"
cask "onlyoffice"

# Casks — corporate additions
cask "docker"
cask "firefox"
cask "dbeaver-community"
cask "raycast"
cask "monitorcontrol"
cask "alt-tab"
cask "font-fira-code-nerd-font"
cask "font-hack-nerd-font"
cask "ghostty"
cask "redisinsight"
```

- [ ] **Step 2: Validate Brewfile parses**

```bash
brew bundle list --file=scripts/profiles/Brewfile.corporate
```

Expected: prints package list. No syntax error.

- [ ] **Step 3: Commit**

```bash
git add scripts/profiles/Brewfile.corporate
git commit -m "feat: add Brewfile.corporate profile for work-style machines"
```

---

### Task 3: Create `scripts/profiles/Brewfile.full`

**Files:**
- Create: `scripts/profiles/Brewfile.full`

- [ ] **Step 1: Write the file**

```ruby
# Brewfile.full — Studio, MBP. Everything. No commented-out blocks
# except for the ones that are intentionally never installed.

# CLI tools — corporate set
brew "stow"
brew "fzf"
brew "eza"
brew "bat"
brew "ripgrep"
brew "neovim"
brew "lazygit"
brew "gnu-sed"
brew "nvm"
brew "bun"
brew "jq"
brew "xh"
brew "git-delta"
brew "mosh"
brew "starship"
brew "dasel"
brew "ast-grep"
brew "prettyping"
brew "expect"
brew "awscli"
brew "groff"
brew "gh"
brew "glab"
brew "libpq"
brew "sqlite"
brew "ffmpeg"

# CLI tools — full additions
brew "nmap"
brew "httrack"

# Disabled — documented for awareness, not installed:
# brew "jless"
# brew "jqp"
# brew "kubectl"
# brew "kubectx"
# brew "kubens"
# brew "derailed/k9s/k9s"

# Casks — corporate set
cask "kitty"
cask "font-symbols-only-nerd-font"
cask "1password"
cask "1password-cli"
cask "google-chrome"
cask "slack"
cask "zoom"
cask "claude-code"
cask "onlyoffice"
cask "docker"
cask "firefox"
cask "dbeaver-community"
cask "raycast"
cask "monitorcontrol"
cask "alt-tab"
cask "font-fira-code-nerd-font"
cask "font-hack-nerd-font"
cask "ghostty"
cask "redisinsight"

# Casks — full additions
cask "discord"
cask "telegram"
cask "wacom-tablet"
cask "clickup"
cask "notion"
cask "burp-suite"
cask "blender"
```

- [ ] **Step 2: Validate Brewfile parses**

```bash
brew bundle list --file=scripts/profiles/Brewfile.full
```

Expected: prints package list. No syntax error.

- [ ] **Step 3: Commit**

```bash
git add scripts/profiles/Brewfile.full
git commit -m "feat: add Brewfile.full profile for Studio/MBP"
```

---

### Task 4: Create `scripts/ohmyzsh-plugins.sh`

**Files:**
- Create: `scripts/ohmyzsh-plugins.sh`

- [ ] **Step 1: Write the script**

```bash
#!/bin/bash
# Clone oh-my-zsh community plugins. Idempotent: skips clones where the
# plugin directory already exists. Strips .git/.github to keep the tree
# light.

set -euo pipefail

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

clone_plugin() {
  local repo="$1" name="$2"
  local dest="$ZSH_CUSTOM/plugins/$name"
  if [ -d "$dest" ]; then
    echo "✓ $name already cloned, skipping"
    return 0
  fi
  echo "→ cloning $name"
  git clone --depth 1 "$repo" "$dest"
  rm -rf "$dest/.git" "$dest/.github"
}

clone_plugin https://github.com/zsh-users/zsh-syntax-highlighting.git zsh-syntax-highlighting
clone_plugin https://github.com/zsh-users/zsh-autosuggestions       zsh-autosuggestions
clone_plugin https://github.com/marlonrichert/zsh-autocomplete.git  zsh-autocomplete
```

- [ ] **Step 2: Make executable**

```bash
chmod +x scripts/ohmyzsh-plugins.sh
```

- [ ] **Step 3: Syntax check**

```bash
bash -n scripts/ohmyzsh-plugins.sh
```

Expected: no output (success).

- [ ] **Step 4: Commit**

```bash
git add scripts/ohmyzsh-plugins.sh
git commit -m "feat: add ohmyzsh-plugins helper script"
```

---

### Task 5: Create `scripts/kitty-setup.sh`

**Files:**
- Create: `scripts/kitty-setup.sh`

- [ ] **Step 1: Write the script**

```bash
#!/bin/bash
# Clear dock icon cache and restart Dock so kitty's custom icon takes
# effect. No-op if kitty isn't installed.

set -euo pipefail

if ! command -v kitty &>/dev/null; then
  echo "kitty not installed, skipping icon refresh"
  exit 0
fi

echo "→ refreshing dock icon cache for kitty"
rm -f /var/folders/*/*/*/com.apple.dock.iconcache 2>/dev/null || true
killall Dock
```

- [ ] **Step 2: Make executable**

```bash
chmod +x scripts/kitty-setup.sh
```

- [ ] **Step 3: Syntax check**

```bash
bash -n scripts/kitty-setup.sh
```

Expected: no output.

- [ ] **Step 4: Commit**

```bash
git add scripts/kitty-setup.sh
git commit -m "feat: add kitty-setup helper for icon cache refresh"
```

---

### Task 6: Create `scripts/macos-defaults.sh`

**Files:**
- Create: `scripts/macos-defaults.sh`

- [ ] **Step 1: Write the script**

```bash
#!/bin/bash
# macOS system-wide defaults. `defaults write` is set-to-value (not
# append), so re-running this is a no-op.

set -euo pipefail

echo "→ setting fast key repeat"
defaults write -g InitialKeyRepeat -int 11

echo "→ disabling press-and-hold accent menu"
defaults write -g ApplePressAndHoldEnabled -bool false
```

- [ ] **Step 2: Make executable**

```bash
chmod +x scripts/macos-defaults.sh
```

- [ ] **Step 3: Syntax check**

```bash
bash -n scripts/macos-defaults.sh
```

Expected: no output.

- [ ] **Step 4: Commit**

```bash
git add scripts/macos-defaults.sh
git commit -m "feat: add macos-defaults helper for keyboard tweaks"
```

---

### Task 7: Create `scripts/stow-prompt.sh`

**Files:**
- Create: `scripts/stow-prompt.sh`

- [ ] **Step 1: Write the script**

```bash
#!/bin/bash
# Interactive stow prompt. Default (Enter) is option 2: stow --adopt.

set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
cd "$DOTFILES_DIR"

echo
echo "Stow options:"
echo "  1) stow         — symlink dotfiles into \$HOME (fails on conflicts)"
echo "  2) stow --adopt — pull existing \$HOME files into the repo, then symlink  [default]"
echo "  3) skip         — do nothing; you'll handle it manually"
read -p "Choice [1/2/3] (default 2): " -n 1 -r choice; echo
choice="${choice:-2}"

case "$choice" in
  1)
    stow .
    ;;
  2)
    stow --adopt .
    echo
    echo "WARNING: 'stow --adopt' overwrites the repo's versions with whatever was in \$HOME."
    echo "Review 'git status' in $DOTFILES_DIR before committing or discarding the changes."
    ;;
  3)
    echo "Skipped. Run 'stow .' from $DOTFILES_DIR when ready."
    ;;
  *)
    echo "Invalid choice ('$choice'), skipping."
    exit 0
    ;;
esac
```

- [ ] **Step 2: Make executable**

```bash
chmod +x scripts/stow-prompt.sh
```

- [ ] **Step 3: Syntax check**

```bash
bash -n scripts/stow-prompt.sh
```

Expected: no output.

- [ ] **Step 4: Commit**

```bash
git add scripts/stow-prompt.sh
git commit -m "feat: add stow-prompt helper with stow/--adopt/skip options"
```

---

### Task 8: Create `scripts/post-stow.sh`

**Files:**
- Create: `scripts/post-stow.sh`

- [ ] **Step 1: Write the script**

```bash
#!/bin/bash
# Post-stow setup: install Node versions via nvm, bootstrap LazyVim
# plugins. Runs after stow so ~/.config/nvim is in place (if stowed).

set -euo pipefail

# Node versions via nvm. nvm is installed by every profile.
echo "→ setting up Node versions via nvm"
export NVM_DIR="$HOME/.nvm"
mkdir -p "$NVM_DIR"

NVM_SH="/opt/homebrew/opt/nvm/nvm.sh"
if [ ! -s "$NVM_SH" ]; then
  echo "nvm.sh not found at $NVM_SH — is nvm installed via brew?"
  exit 1
fi
# shellcheck disable=SC1090
. "$NVM_SH"

nvm install 20
nvm install 22
nvm alias default 22

# LazyVim plugin bootstrap (only if nvim config is in place).
if [ -f "$HOME/.config/nvim/init.lua" ]; then
  echo "→ bootstrapping LazyVim plugins"
  nvim --headless "+Lazy! sync" +qa
else
  echo "→ no ~/.config/nvim/init.lua, skipping LazyVim bootstrap"
fi
```

- [ ] **Step 2: Make executable**

```bash
chmod +x scripts/post-stow.sh
```

- [ ] **Step 3: Syntax check**

```bash
bash -n scripts/post-stow.sh
```

Expected: no output.

- [ ] **Step 4: Commit**

```bash
git add scripts/post-stow.sh
git commit -m "feat: add post-stow helper for node versions and lazyvim bootstrap"
```

---

### Task 9: Rename `.temp.generator.sh` to `personalize.sh` and fix `~/.temp` path

**Files:**
- Rename: `scripts/.temp.generator.sh` → `scripts/personalize.sh`
- Modify: write absolute path `$HOME/.temp` instead of relative `.temp`

**Why:** The current `.temp.generator.sh` writes to a relative `.temp` in the CWD, but `.zshrc` sources `~/.temp` — that only works if the user happens to run setup from `$HOME`. Fix by hardcoding `$HOME/.temp`.

- [ ] **Step 1: Rename via git mv**

```bash
git mv scripts/.temp.generator.sh scripts/personalize.sh
```

- [ ] **Step 2: Rewrite contents**

Replace `scripts/personalize.sh` entirely with:

```bash
#!/bin/bash
# Prompt for personal/work git identities and write ~/.temp with `me`
# and `work` shell functions. Not committed; runs once per machine.

set -euo pipefail

TEMP_FILE="$HOME/.temp"

if [ -f "$TEMP_FILE" ]; then
  read -p "$TEMP_FILE already exists. Overwrite? [y/N]: " -n 1 -r; echo
  [[ $REPLY =~ ^[Yy]$ ]] || { echo "Aborted, leaving $TEMP_FILE alone."; exit 0; }
fi

read -rp "Personal email: " email
read -rp "Personal git user: " user
read -rp "Work email: " workEmail
read -rp "Work git user: " workUser

cat > "$TEMP_FILE" <<EOF
#!/bin/bash

function me() {
  git config user.email "$email"
  git config user.name  "$user"
  echo "local email \$(git config user.email)"
  echo "local user  \$(git config user.name)"
}

function work() {
  git config user.email "$workEmail"
  git config user.name  "$workUser"
  echo "local email \$(git config user.email)"
  echo "local user  \$(git config user.name)"
}
EOF

echo "✓ wrote $TEMP_FILE — run 'source ~/.temp' or open a new shell."
```

- [ ] **Step 3: Make executable**

```bash
chmod +x scripts/personalize.sh
```

- [ ] **Step 4: Syntax check**

```bash
bash -n scripts/personalize.sh
```

Expected: no output.

- [ ] **Step 5: Commit**

```bash
git add scripts/personalize.sh
git commit -m "refactor: rename .temp.generator.sh to personalize.sh, write absolute ~/.temp path"
```

---

### Task 10: Create `scripts/install.sh` (driver)

**Files:**
- Modify: `scripts/install.sh` (replace contents entirely)

**Note:** `scripts/install.sh` already exists with old content (bootstrap-like logic that the new `bootstrap.sh` replaces). This task replaces it with the post-clone driver.

- [ ] **Step 1: Replace `scripts/install.sh` contents**

```bash
#!/bin/bash
# Post-clone installer. Validates profile, runs brew bundle, then the
# universal helper scripts. Called by bootstrap.sh after the repo is
# cloned, but can also be re-run directly:
#
#   ~/dotfiles/scripts/install.sh <light|corporate|full>

set -euo pipefail

PROFILE="${1:-light}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
BREWFILE="$SCRIPT_DIR/profiles/Brewfile.$PROFILE"

if [ ! -f "$BREWFILE" ]; then
  echo "Unknown profile: $PROFILE"
  echo "Available profiles:"
  ls -1 "$SCRIPT_DIR/profiles/" | sed 's/Brewfile\./  /'
  exit 1
fi

echo "==> Installing profile '$PROFILE' from $BREWFILE"
brew bundle install --file="$BREWFILE"

# Preview cleanup, then prompt before destructive removal.
echo
echo "==> Packages installed but not in profile '$PROFILE':"
# `cleanup` (no --force) exits non-zero when there's something to clean.
# We don't want pipefail to kill us here.
set +e
brew bundle cleanup --file="$BREWFILE"
set -e
echo
read -p "Uninstall the packages listed above? [y/N]: " -n 1 -r; echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  brew bundle cleanup --force --file="$BREWFILE"
fi

echo
echo "==> Running helpers"
bash "$SCRIPT_DIR/ohmyzsh-plugins.sh"
bash "$SCRIPT_DIR/kitty-setup.sh"
bash "$SCRIPT_DIR/macos-defaults.sh"
bash "$SCRIPT_DIR/stow-prompt.sh"
bash "$SCRIPT_DIR/post-stow.sh"

# Personalize is one-time per machine.
if [ ! -f "$HOME/.temp" ]; then
  echo
  bash "$SCRIPT_DIR/personalize.sh"
else
  echo
  echo "~/.temp already exists, skipping personalize."
  echo "Re-run $SCRIPT_DIR/personalize.sh to update git identities."
fi

echo
echo "==> Install complete for profile '$PROFILE'."
```

- [ ] **Step 2: Make executable**

```bash
chmod +x scripts/install.sh
```

- [ ] **Step 3: Syntax check**

```bash
bash -n scripts/install.sh
```

Expected: no output.

- [ ] **Step 4: Profile-validation smoke test**

```bash
bash scripts/install.sh nonexistent-profile 2>&1 | head -5
```

Expected: prints "Unknown profile: nonexistent-profile" followed by the list of available profiles. Exits non-zero.

- [ ] **Step 5: Commit**

```bash
git add scripts/install.sh
git commit -m "feat: rewrite install.sh as profile-driven post-clone runner"
```

---

### Task 11: Create `bootstrap.sh` (curl target)

**Files:**
- Create: `bootstrap.sh` at repo root.

- [ ] **Step 1: Write the script**

```bash
#!/bin/bash
# Bootstrap a fresh macOS machine. The curl|bash entry point:
#
#   curl -fsSL https://raw.githubusercontent.com/alexrqs/dotfiles/master/bootstrap.sh | bash
#   curl -fsSL https://raw.githubusercontent.com/alexrqs/dotfiles/master/bootstrap.sh | bash -s corporate
#
# Does the pre-clone work, then hands off to scripts/install.sh.

set -euo pipefail

PROFILE="${1:-light}"
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
REPO_URL="https://github.com/alexrqs/dotfiles.git"

# 1. Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "==> Installing Oh My Zsh"
  RUNZSH=no CHSH=no \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  echo "==> Oh My Zsh already installed"
fi

# 2. Homebrew
if ! command -v brew &>/dev/null; then
  echo "==> Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "==> Homebrew already installed"
fi
eval "$(/opt/homebrew/bin/brew shellenv)"

# 3. Clone dotfiles
if [ ! -d "$DOTFILES_DIR" ]; then
  echo "==> Cloning dotfiles to $DOTFILES_DIR"
  git clone "$REPO_URL" "$DOTFILES_DIR"
else
  echo "==> Dotfiles already cloned at $DOTFILES_DIR"
fi

# 4. Hand off to the post-clone installer
echo "==> Handing off to scripts/install.sh $PROFILE"
exec "$DOTFILES_DIR/scripts/install.sh" "$PROFILE"
```

- [ ] **Step 2: Make executable**

```bash
chmod +x bootstrap.sh
```

- [ ] **Step 3: Syntax check**

```bash
bash -n bootstrap.sh
```

Expected: no output.

- [ ] **Step 4: Commit**

```bash
git add bootstrap.sh
git commit -m "feat: add bootstrap.sh as curl|bash entry point"
```

---

### Task 12: Create `.config/ghostty/config`

**Files:**
- Create: `.config/ghostty/config`

- [ ] **Step 1: Create the directory and file**

```bash
mkdir -p .config/ghostty
```

Write `.config/ghostty/config`:

```
# Ghostty starter config. Mirrors the kitty setup for font size and
# icon-glyph fallback (Symbols Nerd Font). Add a primary font-family
# above the symbols line when you pick one.

font-size = 18

# Primary monospace font (uses system default if unset).
# font-family = Menlo

# Fallback for icon glyphs — multiple font-family lines cascade in ghostty.
font-family = Symbols Nerd Font Mono
```

- [ ] **Step 2: Commit**

```bash
git add .config/ghostty/config
git commit -m "feat: add ghostty starter config mirroring kitty font setup"
```

---

### Task 13: Update `.zshrc` (4 changes)

**Files:**
- Modify: `.zshrc:4` (remove `source ~/.preflight`)
- Modify: `.zshrc:121` (guard `source ~/.temp`)
- Modify: `.zshrc:136` (guard `eval "$(starship init zsh)"`)
- Modify: `.zshrc` (add libpq PATH near `NVM_DIR`/`BUN_INSTALL` block, around line 142–152)

- [ ] **Step 1: Read current .zshrc to confirm line numbers**

```bash
sed -n '1,10p;115,155p' .zshrc
```

Expected: shows the `source ~/.preflight` line, `source ~/.temp`, `eval "$(starship init zsh)"`, and the `NVM_DIR`/`BUN_INSTALL` block. Use these to anchor edits.

- [ ] **Step 2: Remove `source ~/.preflight`**

Delete the line `source ~/.preflight` (currently at line 4). It exports `userPath` which is never read anywhere.

- [ ] **Step 3: Guard `source ~/.temp`**

Change:

```bash
source ~/.temp
```

to:

```bash
[ -f ~/.temp ] && source ~/.temp
```

- [ ] **Step 4: Guard starship init**

Change:

```bash
eval "$(starship init zsh)"
```

to:

```bash
command -v starship &>/dev/null && eval "$(starship init zsh)"
```

(Required because the `light` profile excludes starship.)

- [ ] **Step 5: Add libpq PATH next to BUN_INSTALL**

After the existing `BUN_INSTALL` / `PATH` block (around line 152), insert:

```bash
[ -d /opt/homebrew/opt/libpq/bin ] && export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
```

(libpq is keg-only and only installed on corporate/full. The guard makes the line a no-op on light.)

- [ ] **Step 6: Syntax check**

```bash
zsh -n .zshrc
```

Expected: no output.

- [ ] **Step 7: Commit**

```bash
git add .zshrc
git commit -m "refactor: guard starship/temp sourcing, add libpq PATH, drop dead preflight"
```

---

### Task 14: Delete dead files

**Files:**
- Delete: `scripts/setup.sh`
- Delete: `scripts/install-pack.sh`
- Delete: `scripts/preflight.generator.sh`

**Why:** All three are superseded by `bootstrap.sh`, `scripts/install.sh`, and the Brewfiles. `preflight.generator.sh` writes `userPath` which is dead code (no consumer).

- [ ] **Step 1: Verify nothing references the dead files**

```bash
grep -rn 'setup\.sh\|install-pack\.sh\|preflight\.generator\.sh' \
  --exclude-dir=.git --exclude-dir=docs .
```

Expected: only matches inside the files about to be deleted, plus possibly the old README. If `setup.sh` is referenced from a file you weren't planning to update, surface it before proceeding.

- [ ] **Step 2: Delete via git rm**

```bash
git rm scripts/setup.sh scripts/install-pack.sh scripts/preflight.generator.sh
```

- [ ] **Step 3: Commit**

```bash
git commit -m "chore: delete legacy install scripts (replaced by bootstrap.sh + install.sh)"
```

---

### Task 15: Update `README.md`

**Files:**
- Modify: `README.md`

- [ ] **Step 1: Replace README contents**

```markdown
# .dotfiles

![represent](screenshot.png)

## Install

One-liner on a fresh macOS machine:

```bash
curl -fsSL https://raw.githubusercontent.com/alexrqs/dotfiles/master/bootstrap.sh | bash
```

Defaults to the `light` profile. Pick a profile to match the machine:

```bash
# MacBook Neo — minimum
curl -fsSL https://raw.githubusercontent.com/alexrqs/dotfiles/master/bootstrap.sh | bash -s light

# Air 16/32GB — work-style, no nmap/httrack
curl -fsSL https://raw.githubusercontent.com/alexrqs/dotfiles/master/bootstrap.sh | bash -s corporate

# Studio / MBP — everything
curl -fsSL https://raw.githubusercontent.com/alexrqs/dotfiles/master/bootstrap.sh | bash -s full
```

If `git` isn't installed yet, type `git` in Terminal to trigger the Xcode CLT installer, wait for it to finish, then re-run the command above.

## What it does

1. Installs Oh My Zsh, Homebrew, clones this repo to `~/dotfiles`.
2. Installs the brew packages from `scripts/profiles/Brewfile.<profile>` and offers to uninstall packages not in the profile (`brew bundle cleanup`).
3. Clones oh-my-zsh plugins (syntax-highlighting, autosuggestions, autocomplete).
4. Refreshes the kitty dock icon, sets macOS keyboard tweaks.
5. Prompts to run `stow` / `stow --adopt` / skip for the dotfiles symlinks.
6. Installs Node 20 + 22 via nvm and bootstraps LazyVim plugins.
7. On first install, prompts for personal/work git identities and writes `~/.temp`.

## Re-running

Already cloned? Run the post-clone driver directly:

```bash
~/dotfiles/scripts/install.sh <light|corporate|full>
```

Update git identities later:

```bash
~/dotfiles/scripts/personalize.sh
```

## Design

Spec: `docs/superpowers/specs/2026-05-11-curl-bash-installer-design.md`
```

- [ ] **Step 2: Commit**

```bash
git add README.md
git commit -m "docs: update README for curl|bash installer with profiles"
```

---

## Self-review

### Spec coverage

Every section of the spec has a task:

- Architecture (bootstrap → install.sh flow) → Tasks 10, 11
- File layout → Tasks 1–12 (all the new files)
- Profiles (light/corporate/full Brewfiles) → Tasks 1, 2, 3
- Helper scripts (ohmyzsh-plugins, kitty-setup, macos-defaults, stow-prompt, post-stow, personalize) → Tasks 4–9
- `.zshrc` changes (starship guard, temp guard, libpq PATH, preflight removal) → Task 13
- Ghostty config → Task 12
- Files deleted (setup.sh, install-pack.sh, preflight.generator.sh) → Task 14
- README update → Task 15

No gaps.

### Placeholder scan

No TBDs, no "implement later", no missing code blocks. Every shell script is written out in full. Every Brewfile is written out in full. The .zshrc diff shows the exact lines.

### Type / name consistency

- `BREWFILE` variable used consistently in `install.sh`.
- Helper script paths are always `$SCRIPT_DIR/<name>.sh`.
- Profile names `light` / `corporate` / `full` match between Brewfile filenames, bootstrap arg, and install.sh validation.
- `~/.temp` path is hardcoded the same way in `personalize.sh` (write) and `.zshrc` (read).
