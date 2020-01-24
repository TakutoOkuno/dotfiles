# migration from bash
[ -f ~/.bash_profile ] && source ~/.bash_profile

# history
HISTFILE=$ZDOTDIR/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt extended_history
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_no_store
setopt hist_reduce_blanks
setopt share_history

# zplugin
. "$ZDOTDIR/.zplugin/bin/zplugin.zsh"
autoload -Uz _zplugin
(( ${+_comps} )) && _comps[zplugin]=_zplugin

zplugin load hlissner/zsh-autopair
zplugin ice from"gh-r" as"command"
zplugin load junegunn/fzf-bin
zplugin ice from"gh-r" as"command" mv"powerline-go-* -> powerline-go"
zplugin load justjanne/powerline-go
zplugin load momo-lab/zsh-abbrev-alias
zplugin load zsh-users/zsh-autosuggestions
zplugin load zsh-users/zsh-completions
zplugin load zsh-users/zsh-syntax-highlighting

autoload -U compinit
compinit -C

# powerline
if command -v powerline-go >/dev/null; then
    zmodload zsh/datetime

    function preexec() {
        __TIMER=$EPOCHREALTIME
    }

    function powerline_precmd() {
        local __ERRCODE=$?
        local __DURATION=0

        if [ -n "$__TIMER" ]; then
            local __ERT=$EPOCHREALTIME
            __DURATION="$((__ERT - ${__TIMER:-__ERT}))"
            __DURATION=${__DURATION%%.*} # floor
            unset __TIMER
        fi

        eval "$(powerline-go \
            -duration $__DURATION \
            -error $__ERRCODE \
            -eval \
            -modules ssh,cwd,perms,jobs,exit \
            -modules-right duration,git \
            -numeric-exit-codes \
            -path-aliases $'\~/develop=@DEV,\~/Library/Mobile Documents/com~apple~CloudDocs=@iCloud' \
            -shell zsh \
        )"
    }

    function install_powerline_precmd() {
        for s in "${precmd_functions[@]}"
        do
            if [ "$s" = "powerline_precmd" ]; then
                return
            fi
        done
        precmd_functions+=(powerline_precmd)
    }

    if [ "$TERM" != "linux" ]; then
        install_powerline_precmd
    fi
fi

# abbrev-alias
abbrev-alias -g G='| grep --color=yes -Hn'
abbrev-alias -g F='| fzf'

# alias
alias ls='ls -G'
alias ll='ls -l'

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

function __fuzzy_history()
{
    local _query
    local _command
    if (( $#BUFFER != 0 )); then
        _query="^$BUFFER"
    else
        _query=''
    fi
    _command=$(history -nr 1 | fzf --query="$_query")
    if [ -n "$_command" ]; then
        BUFFER=$_command
        zle accept-line
    fi
}
autoload -Uz __fuzzy_history
zle -N __fuzzy_history
bindkey '^r' __fuzzy_history

# dependent on environment setting
alias ios-localhost-log-viewer='node "/Users/okuno.takuto/develop/revamp/offline-item-search-opez-app/tools/log-viewer/dist/index.js"'
