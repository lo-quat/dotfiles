if [[ ":$PATH:" != *":/opt/homebrew/bin:"* ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

if ! command -v nodenv &> /dev/null || [[ -z "$NODENV_ROOT" ]]; then
    eval "$(nodenv init -)"
fi

source <(fzf --zsh)
export FZF_DEFAULT_OPTS='--height=30%'
export editor='nvim'

autoload -Uz vcs_info

+vi-git-status() {
    if [[ -n $(git status --porcelain 2>/dev/null) ]]; then
        hook_com[unstaged]+='*'
    fi

    local ahead behind
    ahead=$(git rev-list --count @{u}..HEAD 2>/dev/null)
    behind=$(git rev-list --count HEAD..@{u} 2>/dev/null)

    if [[ -n $ahead && $ahead -gt 0 ]]; then
        hook_com[misc]+="↑${ahead}"
    fi
    if [[ -n $behind && $behind -gt 0 ]]; then
        hook_com[misc]+="↓${behind}"
    fi
}

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats ' %F{242}%b%u%m%f'
zstyle ':vcs_info:git:*' actionformats ' %F{242}%b|%a%u%m%f'
zstyle ':vcs_info:git:*' check-for-changes false
zstyle ':vcs_info:git+set-message:*' hooks git-status

precmd() { vcs_info }

setopt PROMPT_SUBST
PROMPT='%F{4}%~%f${vcs_info_msg_0_} %(?.%F{5}.%F{1})❯%f '

alias fnvim='file=$(fzf) && [ -n "$file" ] && nvim "$file"'
