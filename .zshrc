# Power 10k setup prompt if no config exists
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Add snap to path
export PATH=/snap/bin:$PATH

# Set history
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# Set options
setopt appendhistory autocd extendedglob nomatch interactive_comments
zle_highlight=('paste:none')
unsetopt BEEP

# Set locale
export LANGUAGE=en_GB.UTF-8
export LANG=en_GB.UTF-8
export LC_ALL=en_GB.UTF-8

# Import nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Import Haskell
source ~/.ghcup/env

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Completions
autoload -Uz compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots) # Include hidden files

# Configure vim mode
bindkey -v
KEYTIMEOUT=10
bindkey -M viins jk vi-cmd-mode
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -v '^?' backward-delete-char

# Setup fzf
if [[ ! "$PATH" == */home/kendle/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/kendle/.fzf/bin"
fi

eval "$(fzf --zsh)"

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix"

_fzf_compgen_path() {
  fd --hidden . "$1"
}

_fzf_compgen_dir() {
  fd --type=d --hidden . "$1"
}

source ~/.fzf-git.sh/fzf-git.sh

show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always --icons=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"

export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always --icons=always {} | head -200'"

_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always --icons=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo \$'{}"                                        "$@" ;;
    ssh)          fzf --preview 'dig {}'                                                  "$@" ;;
    *)            fzf --preview "$show_file_or_dir_preview"                               "$@" ;;
  esac
}

# Change cursor shape
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] || [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] || [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} == '' ]]   || [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  elif [[ $1 = 'underscore' ]]; then
    echo -ne '\e[3 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() { 
  zle -K viins
  echo -ne '\e[5 q'
}
zle -N zle-line-init
echo -ne '\e[5 q'
preexec() { echo -ne '\e[5 q' }

# Import scripts
# Power 10k
source ~/.local/share/zsh/powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh # Load p10k confi
# Syntax highlighting
source ~/.local/share/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# Auto suggestions
source ~/.local/share/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
# History substring search
source ~/.local/share/zsh/zsh-history-substring-search/zsh-history-substring-search.zsh
bindkey -M vicmd 'j' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
# You should use
source ~/.local/share/zsh/zsh-you-should-use/you-should-use.plugin.zsh

# Set color scheme
wal -q -f rem_dark_1.1.0

# Alieses
eval "$(zoxide init zsh)"
alias cd='z'
alias ls='eza --color=always --icons=always'
alias ll='eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions'
alias tree='eza --tree --color=always --icons=always'
alias md='mkdir'
alias lg='lazygit'
alias refresh='source ~/.zshrc'
alias cls='clear'
