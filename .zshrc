eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(nodenv init -)"
source <(fzf --zsh)
export editor='nvim'
[[ ! -f "${(%):-%x:h}/p10k.zsh" ]] || source "${(%):-%x:h}/p10k.zsh"
