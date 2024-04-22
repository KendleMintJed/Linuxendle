# Power 10k setup prompt if no config exists
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Add path variables
export PATH=/snap/bin:$PATH

# Set history
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# Set options
setopt appendhistory autocd extendedglob nomatch interactive_comments
zle_highlight=('paste:none')
unsetopt BEEP

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

# Alieses
alias ls='exa'
lfcd() { cd "$(command lf -print-last-dir "$@")" }

