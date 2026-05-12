# curl | bash installer with profiles

## Goal

A single command — `curl -fsSL <url>/bootstrap.sh | bash -s <profile>` — that takes a fresh macOS machine to a fully configured dotfiles install. Replaces the current multi-step flow documented in the README (`scripts/setup.sh`, `scripts/install-pack.sh`, `stow .`).

## Why

Multiple machines (MacBook Neo, Air, Studio, MBP) need different package sets. The current flow requires manually cloning the repo first and remembering which scripts to run in which order. A profile-based one-liner removes both problems.

## Non-goals

- Linux/Windows support. macOS only.
- Bootstrapping git/Xcode CLT. The user triggers Xcode CLT install by typing `git` in Terminal before running the installer.
- Capturing manually-installed brew packages outside of profiles. Anything not in the chosen profile's Brewfile is a candidate for removal.

## Architecture

Two-stage install:

1. **`bootstrap.sh`** — small, self-contained script at the repo root. The curl target. Does only the pre-clone work: oh-my-zsh, Homebrew, repo clone. Hands off via `exec` to the post-clone driver.
2. **`scripts/install.sh`** — post-clone driver. Sources the profile's Brewfile, runs `brew bundle`, then runs the universal helper scripts (oh-my-zsh plugins, kitty setup, macOS defaults, stow prompt, personalize).

End-to-end flow:

```
curl … | bash -s <profile>
  └─ bootstrap.sh
       1. install oh-my-zsh (unattended, RUNZSH=no CHSH=no)
       2. install Homebrew, eval brew shellenv
       3. clone repo to ~/dotfiles
       4. exec ~/dotfiles/scripts/install.sh <profile>
            └─ install.sh
                 1. validate profile, locate Brewfile
                 2. brew bundle install
                 3. preview cleanup, prompt to remove not-in-profile
                 4. ohmyzsh-plugins.sh
                 5. kitty-setup.sh
                 6. macos-defaults.sh
                 7. stow-prompt.sh   (default = stow --adopt)
                 8. personalize.sh   (only if ~/.temp absent)
```

## File layout

```
dotfiles/
├── bootstrap.sh                # NEW.
├── scripts/
│   ├── install.sh              # REWRITTEN.
│   ├── personalize.sh          # RENAMED from .temp.generator.sh.
│   ├── profiles/
│   │   ├── Brewfile.light
│   │   ├── Brewfile.corporate
│   │   └── Brewfile.full
│   ├── ohmyzsh-plugins.sh      # NEW.
│   ├── kitty-setup.sh          # NEW.
│   ├── macos-defaults.sh       # NEW.
│   └── stow-prompt.sh          # NEW.
└── (existing dotfiles unchanged)
```

## Profiles

Each profile is a Homebrew Brewfile — declarative state.

- **light** — MacBook Neo. Minimum tools needed for productive shell work.
- **corporate** — Air 16/32GB, work-style machines. Excludes networking/security tools like nmap, httrack.
- **full** — Studio, MBP. Everything.

Profile contents are populated by mapping the current `install-pack.sh` packages into the three tiers. Optional/commented packages from the existing script go to `full` only; uncommented packages go to all three unless they're work-sensitive (nmap, etc.).

`brew bundle install` is idempotent. `brew bundle cleanup` provides "remove not-in-profile" semantics — gated behind a confirmation prompt to prevent surprise removals of packages installed outside the script.

Default profile when no argument is given: **light** (smallest blast radius).

## Helper scripts

All scripts start with `set -euo pipefail`. All are idempotent.

### `ohmyzsh-plugins.sh`
Clones `zsh-syntax-highlighting`, `zsh-autosuggestions`, `zsh-autocomplete` into `$ZSH_CUSTOM/plugins/`. Skips clones where the directory already exists. Strips `.git` and `.github` from clones to keep the repo tree light.

### `kitty-setup.sh`
Guards on `command -v kitty`. Clears `/var/folders/*/*/*/com.apple.dock.iconcache` (best-effort, tolerates missing files) and `killall Dock` so kitty's custom white-cat icon takes effect.

### `macos-defaults.sh`
- `defaults write -g InitialKeyRepeat -int 11` — fast key repeat
- `defaults write -g ApplePressAndHoldEnabled -bool false` — disable hold-key accent menu

### `stow-prompt.sh`
Interactive 3-way choice with `2` (`stow --adopt`) as the enter-default:
1. `stow .` — fail on conflicts
2. `stow --adopt .` — pull existing `$HOME` files into the repo, then symlink (default)
3. skip

After `--adopt`, prints a warning to review `git status` since adopt overwrites repo files with whatever was in `$HOME`.

### `personalize.sh`
Renamed from `.temp.generator.sh`. Prompts for personal/work email and git username, writes `~/.temp` defining `me` and `work` shell functions for swapping git identity. Only invoked from `install.sh` if `~/.temp` doesn't already exist; otherwise the user re-runs it manually when they want to update credentials.

Kept as a runtime-generated file (not committed) so personal info stays out of the public repo.

## `.zshrc` changes

```diff
- source ~/.preflight                       # delete — userPath is dead code
- source ~/.temp                            # line 121
+ [ -f ~/.temp ] && source ~/.temp          # guard for fresh machines
```

## Files deleted

- `scripts/setup.sh` — replaced by `install.sh`
- `scripts/install-pack.sh` — replaced by Brewfiles
- `scripts/preflight.generator.sh` — `userPath` is unused

## Idempotency table

| Step | On re-run |
|---|---|
| bootstrap: oh-my-zsh | `[ -d ~/.oh-my-zsh ]` guard |
| bootstrap: Homebrew | `command -v brew` guard |
| bootstrap: clone | `[ -d ~/dotfiles ]` guard |
| `brew bundle install` | Native idempotency |
| `brew bundle cleanup` | Prompted; declining is no-op |
| ohmyzsh-plugins | Per-plugin directory guard |
| kitty-setup | `killall Dock` is harmless repeat |
| macos-defaults | `defaults write` is set-to-value, not append |
| stow-prompt | User chooses each time |
| personalize | Skipped if `~/.temp` exists |

## Error handling

`set -euo pipefail` everywhere. Explicit `|| true` only in two places where failure is expected and benign:
- `rm` of dock icon cache glob (may not match on fresh machines)
- `brew bundle cleanup` preview run (exits non-zero when nothing to clean)

Anything else failing stops the script with a clear error rather than continuing into a broken state.

## Usage

After this lands:

```bash
# Fresh machine, no profile specified — defaults to light
curl -fsSL https://raw.githubusercontent.com/alexrqs/dotfiles/master/bootstrap.sh | bash

# Specific profile
curl -fsSL https://raw.githubusercontent.com/alexrqs/dotfiles/master/bootstrap.sh | bash -s corporate
curl -fsSL https://raw.githubusercontent.com/alexrqs/dotfiles/master/bootstrap.sh | bash -s full

# Already cloned, re-run setup with a different profile
~/dotfiles/scripts/install.sh full

# Update git identity later
~/dotfiles/scripts/personalize.sh
```
