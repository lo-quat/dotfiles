eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(nodenv init -)"
source <(fzf --zsh)
export editor='nvim'
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
