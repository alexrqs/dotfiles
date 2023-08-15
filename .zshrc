source ~/.preflight
# Fig pre block. Keep at the top of this file.
# [[ -f "$HOME/.fig/shell/zshrc.pre.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.pre.zsh"
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
echo "Loading ZSH path"
export ZSH="/Users/${userPath}/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

echo "Loading ZSH mode"
# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

echo "Loading ZSH plugins"
# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder
export FZF_BASE=/usr/local/opt/fzf/
# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
# source ~/.oh-my-zsh/custom/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh
plugins=(git z zsh-syntax-highlighting bgnotify kubectl zsh-autosuggestions iterm2 fzf)
# bindkey '^\t' autosuggest-accept
# bindkey '^e' autosuggest-execute

echo "Loading oh-my-zsh.sh"
source $ZSH/oh-my-zsh.sh
echo "Loading aliases"
source ~/.aliases
echo "Loading functions"
source ~/.functions
echo "Loading temp"
source ~/.temp

# User configuration
echo "Loading User Configuration"
autoload -U promptinit
promptinit

# autoload -U compinit
# compinit -i

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

NPM_PACKAGES="${HOME}/.npm-packages"

export PATH="$PATH:$NPM_PACKAGES/bin"

# Preserve MANPATH if you already defined it somewhere in your config.
# Otherwise, fall back to `manpath` so we can inherit from `/etc/manpath`.
export MANPATH="${MANPATH-$(manpath)}:$NPM_PACKAGES/share/man"

# HISTFILE="/Users/${userPath}/Dropbox/history/.history"
HISTFILE="/Users/${userPath}/Library/CloudStorage/Dropbox/history/.history"
HISTSIZE=500000
SAVEHIST=500000
setopt appendhistory
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS

echo "Loading Starship"
eval "$(starship init zsh)"

echo "Loading NVM"
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

echo "Loading zsh-hook for nvm"
autoload -U add-zsh-hook
add-zsh-hook chpwd load-nvmrc
# avoid loading nvmrc if we're in a direnv project
# load-nvmrc

echo "Loading Bun"
# bun completions
[ -s "/Users/${userPath}/.bun/_bun" ] && source "/Users/${userPath}/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH";

# bun completions
[ -s "/Users/toptal/.bun/_bun" ] && source "/Users/toptal/.bun/_bun"


# Fig post block. Keep at the bottom of this file.
# [[ -f "$HOME/.fig/shell/zshrc.post.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.post.zsh"
echo "Loading color enhancements"

# ZSH_HIGHLIGHT_STYLES[default]='fg=white'
# ZSH_HIGHLIGHT_STYLES[command]='fg=blue'
ZSH_HIGHLIGHT_STYLES[argument]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[option]='fg=green'
# ZSH_HIGHLIGHT_STYLES[comment]='fg=gray'
# ZSH_HIGHLIGHT_STYLES[path]='fg=cyan'

# ZSH_HIGHLIGHT_STYLES[globbing]='fg=red'
# ZSH_HIGHLIGHT_STYLES[alias]='fg=blue'
# ZSH_HIGHLIGHT_STYLES[function]='fg=magenta'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=green'
ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=blue'
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=white,bold'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=green'
# ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=red'
# ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=blue'
# ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=magenta'
ZSH_HIGHLIGHT_STYLES[rc-quote]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=red'
ZSH_HIGHLIGHT_STYLES[reserved]='fg=cyan,underline'
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=magenta'

ZSH_HIGHLIGHT_STYLES[path-path]='fg=green'
# ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=197'
ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]='fg=white'
# LS_COLORS=$LS_COLORS:'di=01;36:' ; export LS_COLORS
zstyle ':completion:*' list-colors 'di=01;36'

bindkey '^f' forward-word
bindkey '^e' autosuggest-execute
# bindkey -v
