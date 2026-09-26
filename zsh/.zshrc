


# The following lines were added by compinstall

zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s

# zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}'
# zstyle ':completion:*' max-errors 1
zstyle :compinstall filename "$HOME/.zshrc"

export PATH="$PATH:$HOME/scripts"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$PATH:$HOME/go/bin"
export PATH="$PATH:$HOME/.cargo/bin"
# export LUA_PATH="$HOME/.local/lib/lua/?.lua;;"


export SCREENDIR="$HOME/.screen"
export EDITOR="nvim"
export TERMINAL="ghostty"
export BROWSER="cha" # use chawan browser. Needed for arch-wiki-cli

export BKT_TTL=15m
#export VIMRUNTIME=/usr/share/vim/vim81

pgrep -u "$USER" ssh-agent > /dev/null || ssh-agent -t 1h > "$XDG_RUNTIME_DIR/ssh-agent.env"
[[ -f "$SSH_AUTH_SOCK" ]] || source "$XDG_RUNTIME_DIR/ssh-agent.env" > /dev/null


autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=100000
setopt appendhistory notify
bindkey -v
# End of lines configured by zsh-newuser-install

lbrk='%F{magenta}['
rbrk='%F{magenta}]%F{white}'
username='%F{cyan}%n'
at='%F{magenta}@'
hostname='%F{cyan}%m'
curpath='%F{green}%2~'

PROMPT="$lbrk$username$at$hostname $curpath$rbrk $ "

# PS1=$'\e[0;32m%n\e[0m\e[0;34m@\e[0;32m%m:\e[0;31m\[\e[1;35m%~\e[0;31m\]\e[0;32m$\e[0m '

source "$HOME/.aliases" # these aliases are tracked in version control
[[ -f "$HOME/.localaliases" ]] && source "$HOME/.localaliases" # these aliases are untracked, and are local to the machine.


ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# Zplugin stuff
# declare -A ZPLGM
# ZPLGM[HOME_DIR]="$HOME/dotfiles/zsh/.zplugin"
# ZPLGM[BIN_DIR]="$ZPLGM[HOME_DIR]/bin"
### Added by Zplugin's installer
# source "$ZPLGM[BIN_DIR]/zplugin.zsh"
# autoload -Uz _zplugin
#(( ${+_comps} )) && _comps[zplugin]=_zplugin
### End of Zplugin's installer chunk
#
zinit ice atclone"dircolors -b LS_COLORS > clrs.zsh" \
    atpull'%atclone' pick"clrs.zsh" nocompile'!' \
    atload'zstyle ":completion:*" list-colors “${(s.:.)LS_COLORS}”'
zinit light trapd00r/LS_COLORS
# source /usr/share/nvm/init-nvm.sh

[[ -f "$HOME/.atuin/bin/env" ]] && source "$HOME/.atuin/bin/env"

type atuin >/dev/null && eval "$(atuin init zsh)"
#type mise >/dev/null && eval "$(mise activate zsh)"
type luarocks >/dev/null && eval "$(luarocks path)"
export LUA_PATH="$LUA_PATH;$HOME/.local/lib/lua/?.lua"

autoload -U +X bashcompinit && bashcompinit
