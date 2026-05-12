# curl | bash installer with profiles

## Goal

A single command — `curl -fsSL <url>/bootstrap.sh | bash -s <profile>` — that takes a fresh macOS machine to a fully configured dotfiles install. Replaces the current multi-step flow (`scripts/setup.sh`, `scripts/install-pack.sh`, `stow .`).

## Why

Multiple machines (MacBook Neo, Air, Studio, MBP) need different package sets. The current flow requires manually cloning the repo and remembering which scripts to run in which order. A profile-based one-liner removes both problems.

## Non-goals

- Linux/Windows. macOS only.
- Bootstrapping git/Xcode CLT. User triggers Xcode CLT by typing `git` in Terminal before running the installer.
- ComfyUI install. Too GPU/env-specific; user handles manually.
- Preserving manually-installed brew packages outside profiles. `brew bundle cleanup` treats them as candidates for removal (gated by a confirmation prompt).

## Architecture

Two-stage install. `bootstrap.sh` is the small pre-clone script (curl target). `scripts/install.sh` is the post-clone driver.

```
curl … | bash -s <profile>
  └─ bootstrap.sh
       1. install oh-my-zsh (unattended, RUNZSH=no CHSH=no)
       2. install Homebrew, eval brew shellenv
       3. clone repo to ~/dotfiles
       4. exec ~/dotfiles/scripts/install.sh <profile>
            └─ install.sh
                 1. validate profile, locate Brewfile
                 2. brew bundle install --file=Brewfile.<profile>
                 3. brew bundle cleanup preview, prompt to remove not-in-profile
                 4. ohmyzsh-plugins.sh
                 5. kitty-setup.sh
                 6. macos-defaults.sh
                 7. stow-prompt.sh           (default = stow --adopt)
                 8. post-stow.sh             (nvm install 20+22, lazyvim bootstrap)
                 9. personalize.sh           (only if ~/.temp absent)
```

Default profile when no arg is given: **light**.

## File layout

```
dotfiles/
├── bootstrap.sh                # NEW. curl|bash target.
├── .config/
│   └── ghostty/
│       └── config              # NEW. Mirrors kitty font + symbol_map setup.
├── scripts/
│   ├── install.sh              # REWRITTEN. Post-clone driver.
│   ├── personalize.sh          # RENAMED from .temp.generator.sh.
│   ├── profiles/
│   │   ├── Brewfile.light
│   │   ├── Brewfile.corporate
│   │   └── Brewfile.full
│   ├── ohmyzsh-plugins.sh      # NEW.
│   ├── kitty-setup.sh          # NEW.
│   ├── macos-defaults.sh       # NEW.
│   ├── stow-prompt.sh          # NEW.
│   └── post-stow.sh            # NEW. nvm node versions + lazyvim sync.
└── (existing dotfiles unchanged)
```

## Profiles

Each profile is a Homebrew Brewfile — declarative state. Same universal helper scripts run regardless of profile; only the package set differs.

### `Brewfile.light` — MacBook Neo, minimum

CLI tools (`brew`):
- `stow`, `fzf`, `eza`, `bat`, `ripgrep`, `neovim`, `lazygit`, `gnu-sed`
- `nvm`, `bun`
- `jq`, `xh`, `git-delta`, `mosh`
- Commented out: `jless`, `jqp`

Casks:
- `kitty`
- `font-symbols-only-nerd-font`
- `1password`, `1password-cli`
- `google-chrome`
- `slack`, `zoom`
- `orbstack`
- `claude-code`
- `onlyoffice`

### `Brewfile.corporate` — Air 16/32GB, work-style

Everything in light, plus:

CLI tools:
- `starship`, `dasel`, `ast-grep`, `prettyping`, `expect`
- `awscli`, `groff`
- `gh`, `glab`
- `libpq` (psql client only, no server)
- `sqlite`, `ffmpeg`
- Commented out: `kubectl`, `kubectx`, `kubens`, `k9s`

Casks:
- `firefox`, `dbeaver-community`
- `raycast`, `monitorcontrol`, `alt-tab`
- `font-fira-code-nerd-font`, `font-hack-nerd-font`
- `ghostty`
- `redisinsight`

Switches in corporate (not just additions):
- `orbstack` → replaced by `docker`

### `Brewfile.full` — Studio, MBP, everything

Everything in corporate, plus:

CLI tools:
- `nmap`, `httrack`

Casks:
- `discord`, `telegram`
- `wacom-tablet`
- `clickup`, `notion`
- `burp-suite`, `blender`

## Helper scripts

All scripts start with `set -euo pipefail`. All are idempotent.

### `ohmyzsh-plugins.sh`
Clones `zsh-syntax-highlighting`, `zsh-autosuggestions`, `zsh-autocomplete` into `$ZSH_CUSTOM/plugins/`. Per-plugin directory guards. Strips `.git` and `.github` after clone.

### `kitty-setup.sh`
Guards on `command -v kitty`. Clears `/var/folders/*/*/*/com.apple.dock.iconcache` (best-effort) and `killall Dock` so kitty's custom icon takes effect.

### `macos-defaults.sh`
- `defaults write -g InitialKeyRepeat -int 11`
- `defaults write -g ApplePressAndHoldEnabled -bool false`

### `stow-prompt.sh`
Interactive 3-way: stow / stow --adopt / skip. Default (Enter) = `stow --adopt`. After --adopt, warns to review `git status`.

### `post-stow.sh`
Runs after stow has (potentially) landed `.config/nvim` and friends.

1. **Node versions via nvm:**
   ```bash
   export NVM_DIR="$HOME/.nvm"
   mkdir -p "$NVM_DIR"
   . "/opt/homebrew/opt/nvm/nvm.sh"
   nvm install 20
   nvm install 22
   nvm alias default 22
   ```

2. **LazyVim plugin bootstrap** (guarded on `~/.config/nvim/init.lua` existing):
   ```bash
   [ -f "$HOME/.config/nvim/init.lua" ] && nvim --headless "+Lazy! sync" +qa
   ```
   If stow was skipped, the guard fails silently and we don't bootstrap nothing.

### `personalize.sh`
Renamed from `.temp.generator.sh`. Prompts for personal/work email + git username, writes `~/.temp` with `me` and `work` functions. Only invoked from `install.sh` if `~/.temp` doesn't exist; user re-runs manually to update.

## Ghostty config

New file: `.config/ghostty/config`. Starter that mirrors the kitty setup (font size 18, symbols nerd font for icon glyphs via symbol mapping).

```
font-size = 18

# Primary monospace font (uses system default if unset)
# font-family = Menlo

# Fallback for icon glyphs — additive in ghostty (cascades like CSS)
font-family = Symbols Nerd Font Mono
```

Ghostty handles font fallback differently than kitty: multiple `font-family` lines cascade rather than mapping codepoints explicitly (`symbol_map` in kitty). The starter is intentionally minimal; pick a primary font when ready.

## `.zshrc` changes

```diff
- source ~/.preflight                                    # delete (userPath unused)
- eval "$(starship init zsh)"                            # line 136
+ command -v starship &>/dev/null && eval "$(starship init zsh)"
- source ~/.temp                                         # line 121
+ [ -f ~/.temp ] && source ~/.temp
```

Plus, near the existing `BUN_INSTALL` / `NVM_DIR` block:

```
[ -d /opt/homebrew/opt/libpq/bin ] && export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
```

The starship guard is required because the **light** profile excludes starship. Without the guard, light machines print an error every shell start.

## Files deleted

- `scripts/setup.sh` — replaced by `install.sh`
- `scripts/install-pack.sh` — replaced by Brewfiles
- `scripts/preflight.generator.sh` — `userPath` is unused dead code

## Removed from all profiles (vs current `install-pack.sh`)

- `jordanbaird-ice` — removed for good
- `arc` — removed for good

## Notes

- `brew tap homebrew/cask-fonts` is deprecated since 2024. Fonts are in the main cask repo; no tap needed.
- `brew bundle cleanup` is gated behind a confirmation prompt: it previews what would be removed, then asks. Prevents surprise removal of packages installed outside the script.
- `libpq` is keg-only — brew installs it but doesn't put `psql` on `PATH`. Add a guarded export to `.zshrc` next to the existing `BUN_INSTALL`/`NVM_DIR` block: `[ -d /opt/homebrew/opt/libpq/bin ] && export PATH="/opt/homebrew/opt/libpq/bin:$PATH"`. The guard makes it a no-op on light machines that don't install libpq.

## Idempotency

| Step | On re-run |
|---|---|
| bootstrap: oh-my-zsh / brew / clone | Per-step existence guards |
| `brew bundle install` | Native idempotency |
| `brew bundle cleanup` | Prompted; declining is no-op |
| ohmyzsh-plugins | Per-plugin directory guard |
| kitty-setup | `killall Dock` is harmless |
| macos-defaults | `defaults write` is set-to-value |
| stow-prompt | User chooses each time |
| post-stow | `nvm install` is idempotent; `Lazy! sync` is idempotent |
| personalize | Skipped if `~/.temp` exists |

## Error handling

`set -euo pipefail` everywhere. Explicit `|| true` only where failure is expected and benign:
- `rm` of dock icon cache glob (may not match on fresh machines)
- `brew bundle cleanup` preview run (exits non-zero when nothing to clean)

## Usage

```bash
# Fresh machine, no profile specified — defaults to light
curl -fsSL https://raw.githubusercontent.com/alexrqs/dotfiles/master/bootstrap.sh | bash

# Specific profile
curl -fsSL .../bootstrap.sh | bash -s corporate
curl -fsSL .../bootstrap.sh | bash -s full

# Already cloned, re-run setup with a different profile
~/dotfiles/scripts/install.sh full

# Update git identity later
~/dotfiles/scripts/personalize.sh
```
