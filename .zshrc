if [[ ":$PATH:" != *":/opt/homebrew/bin:"* ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

if ! command -v nodenv &> /dev/null || [[ -z "$NODENV_ROOT" ]]; then
    eval "$(nodenv init -)"
fi

source <(fzf --zsh)
export editor='nvim'
source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f "$HOME/dotfiles/.p10k.zsh" ]] || source "$HOME/dotfiles/.p10k.zsh"

alias fnvim='file=$(fzf) && [ -n "$file" ] && nvim "$file"'
