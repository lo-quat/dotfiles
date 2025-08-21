eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(nodenv init -)"
source <(fzf --zsh)
export editor='nvim'
source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f "$HOME/dotfiles/.p10k.zsh" ]] || source "$HOME/dotfiles/.p10k.zsh"
